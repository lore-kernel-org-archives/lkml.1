Return-Path: <linux-kernel-owner+w=401wt.eu-S1760449AbYF3KSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760449AbYF3KSq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 06:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756097AbYF3KSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 06:18:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42012 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886AbYF3KSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 06:18:38 -0400
Date: Mon, 30 Jun 2008 12:18:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Matti Linnanvuori <mattilinn@gmail.com>, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: add compilation checks to pci_unmap_ macros
Message-ID: <20080630101822.GB31497@elte.hu>
References: <ca0148c30806282322u51cf8ecct700f442466b58ee4@mail.gmail.com> <alpine.LNX.1.10.0806291450170.6280@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0806291450170.6280@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0010]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Engelhardt <jengelh@medozas.de> wrote:

> [...] Given that these are no-ops means they are deprecated, is not it 
> the case?)

see higher up in the file:

/* Dynamic DMA mapping stuff.
 * i386 has everything mapped statically.
 */

because everything is 1:1 mapped on 32-bit it's a NOP.

	Ingo
