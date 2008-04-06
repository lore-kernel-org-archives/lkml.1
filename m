Return-Path: <linux-kernel-owner+w=401wt.eu-S1755627AbYDFLIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627AbYDFLIx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 07:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbYDFLIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 07:08:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52458 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640AbYDFLIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 07:08:45 -0400
Date: Sun, 6 Apr 2008 13:08:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, Zhang@ogre.sisk.pl,
       Yanmin <yanmin_zhang@linux.intel.com>
Subject: Re: 2.6.25-rc1: volanoMark regression
Message-ID: <20080406110813.GA21838@elte.hu>
References: <pdYe6zNQVl.A.ieB.zIW9HB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pdYe6zNQVl.A.ieB.zIW9HB@albercik>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> The following report is on the current list of known regressions
> from 2.6.24.  Please verify if the issue is still present in the
> mainline.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9978
> Subject		: 2.6.25-rc1: volanoMark regression
> Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> Date		: 2008-02-13 10:30 (51 days old)
> References	: http://lkml.org/lkml/2008/2/13/128
> Handled-By	: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>

the commit that got bisected there has been reverted 41 days ago:

| commit 62fb185130e4d420f71a30ff59d8b16b74ef5d2b
| Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
| Date:   Mon Feb 25 17:34:02 2008 +0100
|
|     sched: revert load_balance_monitor() changes

there might be other issues in that area but they should be tracked 
separately.

	Ingo
