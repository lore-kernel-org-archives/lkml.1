Return-Path: <linux-kernel-owner+w=401wt.eu-S2992577AbXCWVoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992577AbXCWVoE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 17:44:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992576AbXCWVoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 17:44:04 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:56086 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992573AbXCWVoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 17:44:01 -0400
Subject: Re: [4/5] 2.6.21-rc4: known regressions (v2)
From: john stultz <johnstul@us.ibm.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Bob Tracy <rct@gherkin.frus.com>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070323185028.GR752@stusta.de>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <20070323185028.GR752@stusta.de>
Content-Type: text/plain
Date: Fri, 23 Mar 2007 14:43:58 -0700
Message-Id: <1174686238.5690.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-23 at 19:50 +0100, Adrian Bunk wrote:
> This email lists some known regressions in Linus' tree compared to 2.6.20.
> 
> If you find your name in the Cc header, you are either submitter of one
> of the bugs, maintainer of an affectected subsystem or driver, a patch
> of you caused a breakage or I'm considering you in any other way
> possibly involved with one or more of these issues.
> 
> Due to the huge amount of recipients, please trim the Cc when answering.

> Subject    : boot hangs during IDE detection  (clocksource)
> References : http://lkml.org/lkml/2007/3/19/465
> Submitter  : Bob Tracy <rct@gherkin.frus.com>
> Caused-By  : John Stultz <johnstul@us.ibm.com>
>              commit 6bb74df481223731af6c7e0ff3adb31f6442cfcd
> Handled-By : John Stultz <johnstul@us.ibm.com>
> Status     : problem is being debugged


The incorrect clocksource selection is resolved w/ this patch:
http://lkml.org/lkml/2007/3/22/287

There is still an issue of why the PIT clocksource hangs, but for the
moment the issue its worked-around.

thanks
-john

