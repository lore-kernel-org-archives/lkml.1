Return-Path: <linux-kernel-owner+w=401wt.eu-S1758788AbYCGKBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788AbYCGKBX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 05:01:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbYCGKBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 05:01:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39416 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530AbYCGKBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 05:01:14 -0500
Date: Fri, 7 Mar 2008 11:00:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH] sched: fix the wrong time slice value for SCHED_FIFO
	tasks
Message-ID: <20080307100053.GB3741@elte.hu>
References: <47D09BCA.9050504@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D09BCA.9050504@cn.fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0530]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Miao Xie <miaox@cn.fujitsu.com> wrote:

> Function sys_sched_rr_get_interval returns wrong time slice value for 
> SCHED_FIFO tasks. The time slice for SCHED_FIFO tasks should be 0.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

good catch - applied.

	Ingo
