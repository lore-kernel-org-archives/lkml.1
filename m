Return-Path: <linux-kernel-owner+w=401wt.eu-S1756056AbZAKBLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbZAKBLT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 20:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277AbZAKBLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 20:11:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57208 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbZAKBLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 20:11:09 -0500
Date: Sun, 11 Jan 2009 02:10:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Yinghai Lu <yinghai@kernel.org>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] irq: change irq_desc and kstat_irq_legacy to
	variable sized arrays
Message-ID: <20090111011044.GE12885@elte.hu>
References: <20090110223818.459493000@polaris-admin.engr.sgi.com> <20090110224323.GA17917@elte.hu> <49693A18.5090802@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49693A18.5090802@sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> Here's my latest stats:
> 
> ====== Text/Data ()
> 
>     1 - 128-defconfig
>     2 - 4k-defconfig


small nit, shouldnt this:
>       .1.       .2.    ..final..

be:
>       .1.      .2    .delta

as 'final' is .2 in essence, just in absolute numbers, right? Confusing.


>   5935104     -6144   5928960 -0.10%  TextSize
>   3833856    +43008   3876864 +1.12%  DataSize
>   9734144   -219136   9515008 -2.25%  BssSize
>   2449408   +790528   3239936   +32%  InitSize
>   1884160     +6144   1890304 +0.33%  PerCPU
>    110592   +462848    573440  +418%  OtherSize

and flip around columns 2 and 3 ? It's the delta that matters, and the 
percentage figure.

	Ingo
