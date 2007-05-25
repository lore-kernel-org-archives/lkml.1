Return-Path: <linux-kernel-owner+w=401wt.eu-S1753424AbXEYXYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbXEYXYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 19:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbXEYXYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 19:24:08 -0400
Received: from outbound-mail-36.bluehost.com ([69.89.20.190]:56950 "HELO
	outbound-mail-36.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751880AbXEYXYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 19:24:06 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/6] i386/x86_64: Allow disabling the putstr's =?iso-8859-1?q?from=09compressed_boot?= wrapper
Date: Fri, 25 May 2007 16:23:55 -0700
User-Agent: KMail/1.9.6
Cc: Ben Collins <ben.collins@ubuntu.com>, Andi Kleen <andi@firstfloor.org>,
       Ben Collins <bcollins@ubuntu.com>, linux-kernel@vger.kernel.org
References: <98cd38b5.git.bcollins@ubuntu.com> <1180097543.12570.396.camel@cunning> <46573CE4.8080300@zytor.com>
In-Reply-To: <46573CE4.8080300@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705251623.55551.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 25, 2007 12:45:40 H. Peter Anvin wrote:
> Ben Collins wrote:
> > On Fri, 2007-05-25 at 13:33 +0200, Andi Kleen wrote:
> >> Ben Collins <bcollins@ubuntu.com> writes:
> >>
> >> Why?
> >
> > Because there's no other way to make the kernel totally quiet. We've
> > been patching this out so that the boot sequence has that "clean look".
> >
> > Other than that, it's useless :)
>
> Worse than that, it's harmful.
>
> "Clean look" means "undebuggable."

But how often do you have to debug bootloader or compressed boot code?  In 
fact, most debug output like this isn't very useful after some initial 
debugging, so we usually take it out.  I'm not sure why this would be any 
different...

Jesse


