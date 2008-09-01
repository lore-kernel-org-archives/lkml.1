Return-Path: <linux-kernel-owner+w=401wt.eu-S1753474AbYIARiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbYIARiP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 13:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751018AbYIARiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 13:38:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:33419 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbYIARh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 13:37:59 -0400
Subject: Re: [Bug #11355] Regression in 2.6.27-rc2 when cross-building the
	kernel
From: David Woodhouse <dwmw2@infradead.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <48BC1D8E.9050608@lwfinger.net>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>
	 <VSpL6AnBTS.A.jvH.vaGsIB@albercik>  <200808242334.05993.rjw@sisk.pl>
	 <1220261720.2982.51.camel@pmac.infradead.org>
	 <48BC1D8E.9050608@lwfinger.net>
Content-Type: text/plain
Date: Mon, 01 Sep 2008 18:37:47 +0100
Message-Id: <1220290667.2982.95.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-01 at 11:51 -0500, Larry Finger wrote:
> David Woodhouse wrote:
> > On Sun, 2008-08-24 at 23:34 +0200, Rafael J. Wysocki wrote:
> >> On Saturday, 23 of August 2008, Rafael J. Wysocki wrote:
> >>> This message has been generated automatically as a part of a report
> >>> of recent regressions.
> >>>
> >>> The following bug entry is on the current list of known regressions
> >>> from 2.6.26.  Please verify if it still should be listed and let me know
> >>> (either way).
> >>>
> >>>
> >>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11355
> >>> Subject		: Regression in 2.6.27-rc2 when cross-building the kernel
> >>> Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
> >>> Date		: 2008-08-16 2:38 (8 days old)
> >>> References	: http://marc.info/?l=linux-kernel&m=121885432118368&w=4
> >> As I wrote in the Bugzilla, I'm seeing a related problem.
> >>
> >> Namely, I build kernels on one box, with 'make O=<target>', then I mount
> >> <target> on another one over NFS, 'cd' to it and try to install the kernel
> >> modules with 'make modules_install'.  This results in 'HOSTCC firmware/ihex2fw'
> >> and 'fatal error: ...: Read-only file system'.  It's readily reproducible.
> >>
> >> Commenting out line 1130 of Makefile
> >> ("$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.fwinst obj=firmware __fw_modinst")
> >> obviously helps, so it looks like Makefile.fwinst needs fixing.
> > 
> > I don't like this much, but it should do the trick... please confirm.
> 
> Yes, the patch fixes the problem. Thanks.

Ok, I have a small handful of fixes to send to Linus for 2.6.27; Unless
Sam (or someone else) comes up with a better answer, I'll make sure that
goes with them.

Thanks.

-- 
dwmw2

