Return-Path: <linux-kernel-owner+w=401wt.eu-S1755614AbZDUIam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614AbZDUIam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 04:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754793AbZDUIaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 04:30:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57306 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754893AbZDUIaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 04:30:17 -0400
Date: Tue, 21 Apr 2009 10:29:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Peter Oruba <peter.oruba@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 microcode: work_on_cpu and cleanup of the
	synchronization logic
Message-ID: <20090421082958.GD12512@elte.hu>
References: <1240258569.6195.8.camel@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240258569.6195.8.camel@earth>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:

> From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
> Subject: x86 microcode: work_on_cpu and cleanup of the synchronization logic

Note, this does not apply cleanly to latest -git anymore, due to 
this fixlet for the warnings:

  0917798: x86: fix microcode driver newly spewing warnings

Mind resending with that resolved?

> diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h

( Patch submission nitpick: please always include a diffstat. Thanks! )

	Ingo
