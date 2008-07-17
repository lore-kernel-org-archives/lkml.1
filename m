Return-Path: <linux-kernel-owner+w=401wt.eu-S932626AbYGQWXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626AbYGQWXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 18:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758204AbYGQWXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 18:23:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37202 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757296AbYGQWXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 18:23:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel, use it in more drivers.
Date: Fri, 18 Jul 2008 00:25:33 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       sam@ravnborg.org
References: <1216077806.27455.85.camel@shinybook.infradead.org> <200807172242.51251.rjw@sisk.pl> <1216329939.6672.2.camel@shinybook.infradead.org>
In-Reply-To: <1216329939.6672.2.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807180025.33834.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 17 of July 2008, David Woodhouse wrote:
> On Thu, 2008-07-17 at 22:42 +0200, Rafael J. Wysocki wrote:
> > 
> >   HOSTCC  firmware/ihex2fw - due to: FORCE
> > /home/rafael/src/linux-next/firmware/ihex2fw.c:268: fatal error:
> > opening dependency file firmware/.ihex2fw.d: Read-only file system
> > compilation terminated.
> 
> I'm very confused. I can do this...
> 
>  make INSTALL_FW_PATH=/tmp/foo firmware_install
>  su otheruser
>  touch firmware/.ihex2fw.cmd  (gives EPERM as expected)
>  make INSTALL_FW_PATH=/tmp/foo2 firmware_install
> 
> And it _works_ for me, after I've made that change in
> scripts/Makefile.fwinst. But I don't have .ihex2fw.d -- I
> have .ihex2fw.cmd. What is in your .ihex2fw.d?

There's no '.ihex2fw.d' under 'firmware' in my O= path.

I just do 'make modules_install' on the NFS client, after I have run
'make O=... ... firmware_install' on the server and it prints the above error
message.

Should I add anything to the 'make modules_install' command line?

Rafael
