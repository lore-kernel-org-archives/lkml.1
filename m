Return-Path: <linux-kernel-owner+w=401wt.eu-S1754303AbZAJMTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303AbZAJMTS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 07:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbZAJMTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 07:19:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52521 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206AbZAJMTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 07:19:03 -0500
Date: Sat, 10 Jan 2009 13:18:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>, Jes Sorensen <jes@sgi.com>,
       Jack Steiner <steiner@sgi.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: bad patch in sched.c
Message-ID: <20090110121847.GA26459@elte.hu>
References: <496797C4.6000601@sgi.com> <200901102234.37460.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200901102234.37460.rusty@rustcorp.com.au>
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> cpumask: fix CONFIG_NUMA=y sched.c

doesnt build:

kernel/sched.c: In function ‘__build_sched_domains’:
kernel/sched.c:7701: error: ‘struct static_sched_domain’ has no member named ‘sg’

	Ingo
