Return-Path: <linux-kernel-owner+w=401wt.eu-S1756684AbZCRLfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684AbZCRLfI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 07:35:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756573AbZCRLez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 07:34:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43057 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756555AbZCRLey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 07:34:54 -0400
Date: Wed, 18 Mar 2009 12:34:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] posixtimers: Fix posix clock monotonicity v2
Message-ID: <20090318113430.GD32233@elte.hu>
References: <49BF3F73.5090007@jp.fujitsu.com> <49C0CFC2.7080604@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C0CFC2.7080604@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:

> Impact: Regression fix (against clock_gettime() backwarding bug)

Looks good, thanks! Would you mind to post a version against -tip?

  http://people.redhat.com/mingo/tip.git/README

Which already has a __task_delta_exec() (different version).

Thanks,

	Ingo
