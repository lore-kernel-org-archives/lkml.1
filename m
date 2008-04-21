Return-Path: <linux-kernel-owner+w=401wt.eu-S1760215AbYDUTFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760215AbYDUTFo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 15:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753834AbYDUTFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 15:05:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43102 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753795AbYDUTFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 15:05:33 -0400
Date: Mon, 21 Apr 2008 21:05:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: don't ever allocate PTEs from lowmem
Message-ID: <20080421190519.GA3104@elte.hu>
References: <20080421185703.GA5022@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080421185703.GA5022@damson.getinternet.no>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0048]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> Hi,
> 
> This is needed for the kernel to boot properly without OOMing if PSE 
> is not present or disabled for some reason. It is the fix that you 
> proposed for the kmemcheck OOM-on-boot case. It would also be possible 
> to check the PSE feature before deciding where to allocate from, but I 
> don't think it really matters.
> 
> Looks ok?

yes, looks good - thanks, applied.

> (And yes, this DOES fix the OOM for me. :-D)

great :)

	Ingo
