Return-Path: <linux-kernel-owner+w=401wt.eu-S1754503AbYGZP4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbYGZP4X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 11:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbYGZP4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 11:56:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34890 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768AbYGZP4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 11:56:14 -0400
Date: Sat, 26 Jul 2008 17:55:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Paalanen <pq@iki.fi>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <srostedt@redhat.com>, proski@gnu.org,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] x86: fix mmiotrace 8-bit register decoding
Message-ID: <20080726155557.GA10224@elte.hu>
References: <20080628214626.5f9199d7@daedalus.pq.iki.fi> <20080630123736.GA4011@elte.hu> <20080630234837.118fff8c@daedalus.pq.iki.fi> <19f34abd0806301441w52a9d9e7h42336e05e10f32a9@mail.gmail.com> <20080722220035.0c193738@ct200006>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080722220035.0c193738@ct200006>
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


* Pekka Paalanen <pq@iki.fi> wrote:

> From 8321edde04244cc91470da5a7a71b79b704b0da1 Mon Sep 17 00:00:00 2001
> From: Pekka Paalanen <pq@iki.fi>
> Date: Mon, 21 Jul 2008 18:49:56 +0300
> Subject: [PATCH] x86: fix mmiotrace 8-bit register decoding
> 
> When SIL, DIL, BPL or SPL registers were used in MMIO, the datum
> was extracted from AH, BH, CH, or DH, which are incorrect.
> 
> Signed-off-by: Pekka Paalanen <pq@iki.fi>
> ---
> 
> This patch was cooked in Linus' tree because I couldn't get linux-next 
> to boot properly at the time. It applies cleanly to tip/master though. 
> Another problem I noticed is with non-page-aligned mappings, but 
> that's a different story.

applied to tip/tracing/mmiotrace - thanks Pekka!

	Ingo
