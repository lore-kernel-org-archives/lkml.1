Return-Path: <linux-kernel-owner+w=401wt.eu-S1761437AbXKAO6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761437AbXKAO6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 10:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754655AbXKAO6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 10:58:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54177 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756464AbXKAO6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 10:58:12 -0400
Date: Thu, 1 Nov 2007 15:57:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de
Subject: Re: [PATCH] show right output for cpuinfo
Message-ID: <20071101145753.GA3767@elte.hu>
References: <1193910960937-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193910960937-git-send-email-gcosta@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Glauber de Oliveira Costa <gcosta@redhat.com> wrote:

> in x86_64 smp systems, a regression was introduced a few days after 
> 2.6.23, on its way to 2.6.23. Bisection leads me to commit 
> 92cb7612aee39642d109b8d935ad265e602c0563.
> 
> The problem is that the output of 'cat /proc/cpuinfo' shows 0 as the 
> id of all cpus of a smp system. As far as I know, this only happens on 
> x86_64 systems.
> 
> This problem was first noticed by Ravikiran. A simple patch follows

oops, thanks for tracking this down!

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
