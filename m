Return-Path: <linux-kernel-owner+w=401wt.eu-S964923AbXCKTUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964923AbXCKTUA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 15:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964930AbXCKTUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 15:20:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37593 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964923AbXCKTT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 15:19:59 -0400
Date: Sun, 11 Mar 2007 20:19:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Michael S. Tsirkin" <mst@mellanox.co.il>
Cc: Roland Dreier <roland.list@gmail.com>, Roland Dreier <rdreier@cisco.com>,
       general@lists.openfabrics.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: lockdep question (was Re: IPoIB caused a kernel: BUG: soft lockup detected on CPU#0!)
Message-ID: <20070311191920.GA7049@elte.hu>
References: <45E552FC.4040305@mellanox.co.il> <f8ca0a150703030937u61bcd9aj200415b76c00d151@mail.gmail.com> <20070311135051.GA31985@mellanox.co.il> <20070311150431.GE31985@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070311150431.GE31985@mellanox.co.il>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael S. Tsirkin <mst@mellanox.co.il> wrote:

> After adding some printks, I started getting these:
> 
> [  597.036720] BUG: MAX_STACK_TRACE_ENTRIES too low!

this should go away if you double the size of MAX_STACK_TRACE_ENTRIES in 
kernel/lockdep_internals.h. (keep it a power of two) If it doesnt go 
away then it might signal some sort of leak.

	Ingo
