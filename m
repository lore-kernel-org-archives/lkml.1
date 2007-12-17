Return-Path: <linux-kernel-owner+w=401wt.eu-S1758036AbXLQRqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036AbXLQRqm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 12:46:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754902AbXLQRqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 12:46:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60636 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753475AbXLQRqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 12:46:32 -0500
Date: Mon, 17 Dec 2007 18:46:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: cleanup i387_32.c according to checkpatch
Message-ID: <20071217174621.GC28219@elte.hu>
References: <20071217171507.GD7882@cvg.cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071217171507.GD7882@cvg.cvg>
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> This patch does cleanup checkpatch warnings/errors on i387_32.c

thanks, applied.

> The old and new i387_32.s (asm listings) were checked with diff to be 
> identical so it's safe to apply this patch.

excellent. My scripts agree too:

   text    data     bss     dec     hex filename
   3930       4       0    3934     f5e i387_32.o.before
   3930       4       0    3934     f5e i387_32.o.after

	Ingo
