Return-Path: <linux-kernel-owner+w=401wt.eu-S932786AbYGQUkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786AbYGQUkg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 16:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757545AbYGQUk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 16:40:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36802 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754388AbYGQUk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 16:40:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel, use it in more drivers.
Date: Thu, 17 Jul 2008 22:42:50 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       sam@ravnborg.org
References: <1216077806.27455.85.camel@shinybook.infradead.org> <200807162328.37754.rjw@sisk.pl> <1216248152.1862.21.camel@shinybook.infradead.org>
In-Reply-To: <1216248152.1862.21.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807172242.51251.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 17 of July 2008, David Woodhouse wrote:
> On Wed, 2008-07-16 at 23:28 +0200, Rafael J. Wysocki wrote:
> > On Wednesday, 16 of July 2008, David Woodhouse wrote:
> > > On Tue, 2008-07-15 at 13:49 -0700, David Woodhouse wrote:
> > > > I need to hassle Sam about that.
> > > 
> > > I think I have it. Rafael, does _this_ fix it for you?
> > 
> > No, but the error message seems to be different:
> > 
> >   HOSTCC  firmware/ihex2fw
> > /home/rafael/src/linux-next/firmware/ihex2fw.c:268: fatal error: opening dependency file firmware/.ihex2fw.d: Read-only file system
> > compilation terminated.
> 
> Hm, can you do that again with V=2?

  HOSTCC  firmware/ihex2fw - due to: FORCE
/home/rafael/src/linux-next/firmware/ihex2fw.c:268: fatal error: opening dependency file firmware/.ihex2fw.d: Read-only file system
compilation terminated.

Thanks,
Rafael
