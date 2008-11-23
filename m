Return-Path: <linux-kernel-owner+w=401wt.eu-S1758931AbYKWPP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758931AbYKWPP1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 10:15:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758254AbYKWPPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 10:15:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60725 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758242AbYKWPPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 10:15:18 -0500
Date: Sun, 23 Nov 2008 16:15:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: tglx@linutronix.de, lkml <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] irq.h remove padding from irq_desc on 64bits
Message-ID: <20081123151507.GE3224@elte.hu>
References: <1227450883.2970.11.camel@castor.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227450883.2970.11.camel@castor.localdomain>
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


* Richard Kennedy <richard@rsk.demon.co.uk> wrote:

> struct irq_desc : reorder to remove padding on 64bits
>     
> shrinks irq_desc to 128 bytes which saves data space & cache lines
> 
> On a generic x86_64/SMP build this reduces the reported data size by
> 64k.
> 
> Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
> 
> ----
> This patch is against 2.628-rc6, built & tested on AMD 64x2 desktop.

nice one - applied to tip/irq/core, thanks Richard!

	Ingo
