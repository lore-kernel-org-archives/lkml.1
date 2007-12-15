Return-Path: <linux-kernel-owner+w=401wt.eu-S1764418AbXLOH0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764418AbXLOH0S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 02:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbXLOH0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 02:26:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43441 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbXLOH0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 02:26:06 -0500
Date: Sat, 15 Dec 2007 08:25:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: ak@suse.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, markus.t.metzger@gmail.com,
       suresh.b.siddha@intel.com, roland@redhat.com, akpm@linux-foundation.org,
       mtk.manpages@gmail.com, Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch 4/5] x86, ptrace: new ptrace BTS API
Message-ID: <20071215072538.GA12110@elte.hu>
References: <20071214180531.A20647@sedona.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071214180531.A20647@sedona.ch.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Markus Metzger <markus.t.metzger@intel.com> wrote:

> Here's the new ptrace BTS API that supports two different overflow 
> handling mechanisms (wrap-around and buffer-full-signal) to support 
> two different use cases (debugging and profiling).
> 
> It further combines buffer allocation and configuration.
> 
> Opens:
> - memory rlimit
> - overflow signal
> 
> What would be the right signal to use?

i think we tend to have such signal targets configurable (like in the 
POSIX timers APIs) - or we could use SIGIO. I've Cc:-ed Ulrich - maybe 
he has some specific ideas how to structure this.

	Ingo
