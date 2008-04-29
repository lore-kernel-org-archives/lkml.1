Return-Path: <linux-kernel-owner+w=401wt.eu-S1759167AbYD2JwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759167AbYD2JwL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 05:52:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751133AbYD2Jv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 05:51:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53332 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033AbYD2Jv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 05:51:57 -0400
Date: Tue, 29 Apr 2008 11:51:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Simner <djs203@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] sched_info_switch not being called according to
	documentation (10545)
Message-ID: <20080429095146.GD23198@elte.hu>
References: <20080429090859.GA16568@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429090859.GA16568@srcf.ucam.org>
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


* David Simner <djs203@srcf.ucam.org> wrote:

> Hi,
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=10545
> 
> sched_stats.h says that __sched_info_switch is "called when prev != 
> next" in the comment.  sched.c should therefore do that, see the patch 
> below:

thanks David, applied you fix.

	Ingo
