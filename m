Return-Path: <linux-kernel-owner+w=401wt.eu-S1753803AbYJCLkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbYJCLkX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 07:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbYJCLkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 07:40:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39227 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600AbYJCLkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 07:40:11 -0400
Date: Fri, 3 Oct 2008 13:39:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] cpuset doesn't seem to be so const
Message-ID: <20081003113955.GA14861@elte.hu>
References: <48E5EF82.9070100@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48E5EF82.9070100@gmail.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> This fixes a warning on last -tip:
> 
> kernel/cpuset.c: Dans la fonction «scan_for_empty_cpusets» :
> kernel/cpuset.c:1932: attention : passing argument 1 of «list_add_tail» discards qualifiers from pointer target type
> 
> Actually the struct cpuset *root passed in parameter to scan_for_empty_cpusets
> is not supposed to be const since an entry is added on the tail of its list.
> Just correct the qualifier.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

applied to tip/sched/cpusets, thanks Frederic!

	Ingo
