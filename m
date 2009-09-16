Return-Path: <linux-kernel-owner+w=401wt.eu-S1759006AbZIPTpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759006AbZIPTpK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 15:45:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756030AbZIPTpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 15:45:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41513 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754252AbZIPTpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 15:45:07 -0400
Date: Wed, 16 Sep 2009 21:45:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Serge Belyshev <belyshev@depni.sinp.msu.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Epic regression in throughput since v2.6.23
Message-ID: <20090916194507.GA27456@elte.hu>
References: <20090906205952.GA6516@elte.hu> <87hbvdiogq.fsf@depni.sinp.msu.ru> <873a6xdqwq.fsf@depni.sinp.msu.ru> <20090909155223.GA12065@elte.hu> <87my53vo6d.fsf@depni.sinp.msu.ru> <20090910065306.GB3920@elte.hu> <87ljkm9yew.fsf@depni.sinp.msu.ru> <20090911061024.GA27833@elte.hu> <87iqfmx3tr.fsf@depni.sinp.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87iqfmx3tr.fsf@depni.sinp.msu.ru>
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

> Note that the disabling NEW_FAIR_SLEEPERS doesn't fix 3% regression 
> from v2.6.23, but instead makes "make -j4" runtime another 2% worse 
> (27.05 -> 27.72).

Ok, i think we've got a handle on that finally - mind checking latest 
-tip?

	Ingo
