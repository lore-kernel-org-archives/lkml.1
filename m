Return-Path: <linux-kernel-owner+w=401wt.eu-S1758792AbYAHHLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758792AbYAHHLz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 02:11:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754787AbYAHHLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 02:11:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57535 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754658AbYAHHLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 02:11:47 -0500
Date: Tue, 8 Jan 2008 08:11:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, tglx@tglx.de, hpa@zytor.com
Subject: Re: [patch 2/2] Use the stack frames to get exact stack-traces for
	CONFIG_FRAMEPOINTER on x86-64
Message-ID: <20080108071129.GB31838@elte.hu>
References: <20080107211437.5ba42f18@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080107211437.5ba42f18@laptopd505.fenrus.org>
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> x86 32 bit already has this feature: This patch uses the stack frames 
> with frame pointer into an exact stack trace, by following the frame 
> pointer. This only affects kernels built with the CONFIG_FRAME_POINTER 
> config option enabled, and greatly reduces the amount of noise in 
> oopses.

nice! Applied.

> The code tries to use the frame pointers to do a backtrace, but if it 
> smells iffy or invalid, falls back to the traditional way of printing 
> backtraces, to make sure that at least some useful backtrace is 
> created.
>
> Due to the fragility and importance of the backtrace code, this needs 
> to be well reviewed and well tested before merging into mainlne.

yeah, agreed. But i think this is still fundamentally more robust than 
the unwind info based backtracer. Cool stuff!

	Ingo
