Return-Path: <linux-kernel-owner+w=401wt.eu-S1753624AbYCKQTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624AbYCKQTe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 12:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752406AbYCKQTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 12:19:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39411 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221AbYCKQTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 12:19:24 -0400
Date: Tue, 11 Mar 2008 17:19:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.25-rc5] x86: correct/clarify comment in nops.h
Message-ID: <20080311161901.GA32355@elte.hu>
References: <18390.43171.335608.379379@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18390.43171.335608.379379@harpo.it.uu.se>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0147]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mikael Pettersson <mikpe@it.uu.se> wrote:

> <asm-x86/nops.h> describes certain multibyte instructions as "generic" 
> nops when in fact they aren't nops at all in 64-bit mode (missing 
> REX.W causing truncation of a register).
> 
> Update the comment to state that K8 or P6 style nops should be used in 
> 64-bit mode. This matches what the alternatives code does.

>  /* generic versions from gas
>     1: nop
> +   the following instructions are NOT nops in 64-bit mode,
> +   for 64-bit mode use K8 or P6 nops instead
>     2: movl %esi,%esi
>     3: leal 0x00(%esi),%esi
>     4: leal 0x00(,%esi,1),%esi

thanks Mikael, applied.

	Ingo
