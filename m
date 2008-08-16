Return-Path: <linux-kernel-owner+w=401wt.eu-S1754470AbYHPU0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470AbYHPU0k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 16:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754126AbYHPU0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 16:26:18 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63170 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752883AbYHPU0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 16:26:17 -0400
Date: Sat, 16 Aug 2008 21:25:37 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Arjan van de Ven <arjan@infradead.org>
cc: Cyrill Gorcunov <gorcunov@gmail.com>, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] x86: apic - unify lapic_resume
In-Reply-To: <20080816130008.349b031d@infradead.org>
Message-ID: <Pine.LNX.4.55.0808162113280.17944@cliff.in.clinika.pl>
References: <1218914515-26377-1-git-send-email-gorcunov@gmail.com>
 <f87881899957b7aa08b827cdc6b5dd8cf53e4730.1218914042.git.gorcunov@gmail.com>
 <722b5bc0303212ca203cadeedae5ede3e23eccb7.1218914042.git.gorcunov@gmail.com>
 <Pine.LNX.4.55.0808162041190.17944@cliff.in.clinika.pl>
 <20080816130008.349b031d@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Aug 2008, Arjan van de Ven wrote:

> it's not like you can/want to go over 128 cpus on a 32 bit kernel
> though..

 That's a quantitative rather than a qualitative limitation though.  I can
see no reason why limiting the number of CPUs would preclude the use of
the x2APIC mode altogether -- the extra CPUs will simply be ignored and
never waken up.  And with smaller systems and a 32-bit kernel one may
still want to get the small performance gain from using the MSRs rather
than going through the TLB for example.

 Similarly there is some RAM size limitation with the 32-bit configuration
too, but that does not prevent us from using however much we can in the
32-bit mode either. ;)

  Maciej
