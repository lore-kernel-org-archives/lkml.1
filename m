Return-Path: <linux-kernel-owner+w=401wt.eu-S1764039AbXFRPCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764039AbXFRPCF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 11:02:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763341AbXFRPBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 11:01:55 -0400
Received: from mail.gmx.net ([213.165.64.20]:57527 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1763332AbXFRPBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 11:01:54 -0400
Content-Type: text/plain; charset="us-ascii"
Date: Mon, 18 Jun 2007 17:01:52 +0200
From: "Michael Kerrisk" <mtk-manpages@gmx.net>
In-Reply-To: <E1I0HsK-0000of-5v@be1.lrz>
Message-ID: <20070618150152.211030@gmx.net>
MIME-Version: 1.0
References: <8x3Cc-1LD-13@gated-at.bofh.it> <E1I0HsK-0000of-5v@be1.lrz>
Subject: Re: man-pages-2.57 is released
To: 7eggert@gmx.de, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
X-Authenticated: #24879014
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX18QIiowv6EQ6ugZA72T++7yrBm7ZBH/xSBaX2FCss
 CrXUoQFkXeHUbzeY623OkPgtAqhUClwS6F3w== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: UuRDLgQ4ZDIrB8isAWc2jqh5emhmY0Gx
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Michael Kerrisk <mtk-manpages@gmx.net> wrote:
> 
> > ./man2/ioperm.2
> >      FIXME is the following ("Only the first 0x3ff I/O ports can be
> >      specified in this manner") still true?  Looking at changes in
> >      include/asm-i386/processor.h between 2.4 and 2.6 suggests
> >      that the limit is different in 2.6.
> 
> You now have the full 64Kb port bitmap (8 KB).
> BTW1: linux/arch/i386/kernel/ioport.c still states having 8K of 
> bitmaps to
> be excessive (and implicitely and now wrongly as not being done). Since
> there should only be few processes requiring iopl, the 8K should not be
> excessive. We need a native speaker to change this text, at least not me
> right now.

If someone can come up with a technical description of what
should should go in the man page, I'm happy to fix the English.

> CC Linus, because he admitted fiddeling with this file. (No MAINTAINER
> found)
> 
> 
> BTW2: My (possibly outdated) iopl manpage states that you'll need to be
> root
> change the iopl, but you only need CAP_SYS_RAWIO in order to increase the
> iopl.

The current page includes this text under ERRORS

       EPERM  The  calling process has insufficient privilege to
              call  iopl();  the  CAP_SYS_RAWIO  capability   is
              required.

Cheers,

Michael
-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7 

Want to help with man page maintenance?  
Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages , 
read the HOWTOHELP file and grep the source 
files for 'FIXME'.

