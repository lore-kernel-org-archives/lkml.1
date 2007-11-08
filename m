Return-Path: <linux-kernel-owner+w=401wt.eu-S1762808AbXKHTpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762808AbXKHTpk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 14:45:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761558AbXKHTpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 14:45:23 -0500
Received: from www.tglx.de ([62.245.132.106]:40801 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761428AbXKHTpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 14:45:22 -0500
Subject: Re: kbuild: possible regression?
From: Jan Altenberg <jan.altenberg@linutronix.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: miltonm@bga.com, linux-kernel@vger.kernel.org,
       linux-kbuild <linux-kbuild@vger.kernel.org>, tglx@linutronix.de
In-Reply-To: <20071031094306.GB24100@uranus.ravnborg.org>
References: <1193821430.3839.88.camel@bender.lan>
	 <20071031094306.GB24100@uranus.ravnborg.org>
Content-Type: text/plain
Date: Thu, 08 Nov 2007 20:45:01 +0100
Message-Id: <1194551101.6014.156.camel@bender.lan>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

> > commit 0b35786d77ba4037f181982cc8ca20a7a3bf0fd2
> > Author: Milton Miller <miltonm@bga.com>
> > Date:   Fri Sep 21 18:09:02 2007 -0500
> > 
> >     kbuild: call make once for all targets when O=.. is used
> >     
> >     Change the invocations of make in the output directory Makefile and the
> >     main Makefile for separate object trees to pass all goals to one $(MAKE)
> >     via a new phony target "sub-make" and the existing target _all.
> >     
> >     When compiling with separate object directories, a separate make is called
> >     in the context of another directory (from the output directory the main
> >     Makefile is called, the Makefile is then restarted with current directory
> >     set to the object tree).  Before this patch, when multiple make command
> >     goals are specified, each target results in a separate make invocation.
> >     With make -j, these invocations may run in parallel, resulting in multiple
> >     commands running in the same directory clobbering each others results.
> >     
> >     I did not try to address make -j for mixed dot-config and no-dot-config
> >     targets.  Because the order does matter, a solution was not obvious.
> >     Perhaps a simple check for MAKEFLAGS having -j and refusing to run would
> >     be appropriate.
> >     
> >     Signed-off-by: Milton Miller <miltonm@bga.com>
> >     Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> > 
> > So, am I facing a kbuild regression?
> 
> Yes - I will try to fix it during the weekend (if Milton does not beat me).
> Thanks for reporting and bisecting!

Have you made any progress on this? Let me know, if I can assist with
testing.

Cheers,
	Jan

