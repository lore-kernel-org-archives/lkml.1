Return-Path: <linux-kernel-owner+w=401wt.eu-S1752522AbZIIPw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbZIIPw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 11:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752261AbZIIPw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 11:52:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60293 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181AbZIIPw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 11:52:27 -0400
Date: Wed, 9 Sep 2009 17:52:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Serge Belyshev <belyshev@depni.sinp.msu.ru>
Cc: Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: Epic regression in throughput since v2.6.23
Message-ID: <20090909155223.GA12065@elte.hu>
References: <20090906205952.GA6516@elte.hu> <87hbvdiogq.fsf@depni.sinp.msu.ru> <873a6xdqwq.fsf@depni.sinp.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <873a6xdqwq.fsf@depni.sinp.msu.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Serge Belyshev <belyshev@depni.sinp.msu.ru> wrote:

> Serge Belyshev <belyshev@depni.sinp.msu.ru> writes:
> >[snip]
> 
> I've updated the graphs, added kernels 2.6.24..2.6.29:
> http://img186.imageshack.us/img186/7029/epicmakej4.png
> 
> And added comparison with best-performing 2.6.23 kernel:
> http://img34.imageshack.us/img34/7563/epicbfstips.png

Thanks!

I think we found the reason for that regression - would you mind 
to re-test with latest -tip, e157986 or later?

If that works for you i'll describe our theory.

	Ingo
