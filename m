Return-Path: <linux-kernel-owner+w=401wt.eu-S1754649AbXLRKzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbXLRKzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 05:55:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbXLRKz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 05:55:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55108 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352AbXLRKz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 05:55:27 -0500
Date: Tue, 18 Dec 2007 11:55:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gregory Haskins <ghaskins@novell.com>
Cc: srostedt@redhat.com, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: dynamically update the root-domain span/online
	maps
Message-ID: <20071218105513.GA9002@elte.hu>
References: <20071218023805.4390.19471.stgit@novell1.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071218023805.4390.19471.stgit@novell1.haskins.net>
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


* Gregory Haskins <ghaskins@novell.com> wrote:

> Hi Steven,
>   I posted a suspend-to-ram fix to sched-devel earlier today:
> 
> http://lkml.org/lkml/2007/12/17/445
> 
> This fix should also be applied to -rt as I introduced the same 
> regression there.  Here is a version of the fix for 23-rt13.  I can 
> submit a version for 24-rc5-rt1 at your request.

well since i reverted the original patch, there's no regression. The 
question is, do we know whether this new patch works fine wrt. s2ram?

	Ingo
