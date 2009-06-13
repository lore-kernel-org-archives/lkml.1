Return-Path: <linux-kernel-owner+w=401wt.eu-S1764370AbZFMVRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764370AbZFMVRB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 17:17:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755489AbZFMVQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 17:16:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56868 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755433AbZFMVQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 17:16:51 -0400
Date: Sat, 13 Jun 2009 23:16:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>, Mike Frysinger <vapier.adi@gmail.com>
Cc: benh@kernel.crashing.org, linuxppc-dev@ozlabs.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] powerpc: perf_counter: Enable use of software
	counters on 32-bit powerpc
Message-ID: <20090613211645.GA21611@elte.hu>
References: <18995.39910.109998.926269@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18995.39910.109998.926269@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0165]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mackerras <paulus@samba.org> wrote:

> +extern void set_perf_counter_pending(void);

btw., Mike Frysinger pointed out that this prototype should be in 
include/linux/perf_counter.h, not spread out in every architecture 
pointlessly.

	Ingo
