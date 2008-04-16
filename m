Return-Path: <linux-kernel-owner+w=401wt.eu-S1763009AbYDPOlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763009AbYDPOlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 10:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754460AbYDPOlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 10:41:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44054 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754237AbYDPOlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 10:41:05 -0400
Date: Wed, 16 Apr 2008 16:40:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix find_next_bit breakage on ppc and powerpc
Message-ID: <20080416144051.GH24383@elte.hu>
References: <1208191719.12568.1247788911@webmail.messagingengine.com> <20080416125724.GC6304@elte.hu> <20080416135508.GA16439@mailshack.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080416135508.GA16439@mailshack.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander van Heukelum <heukelum@mailshack.com> wrote:

> Powerpc (and ppc) have their have some code in their bitops.h which 
> used to be exacly the same as asm-generic/bitops/find.h. Include this 
> header instead.
> 
> This should also fix the compile problems due to the generic 
> find_next_bit changes. Those were fixed by Thomas Gleixner in 
> asm-generic/bitops/find.h earlier.
> 
> Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

thanks, applied. I dropped:

  Subject: powerpc: fix powerpc build
  From: Thomas Gleixner <tglx@linutronix.de>

and i'm keeping:

  Subject: generic: find_next_bit() fix
  From: Thomas Gleixner <tglx@linutronix.de>

should i also drop:

  Subject: find_first_bit() ppc fix
  From: Thomas Gleixner <tglx@linutronix.de>

?

	Ingo
