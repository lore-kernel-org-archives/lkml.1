Return-Path: <linux-kernel-owner+w=401wt.eu-S1753301AbYHPTxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbYHPTxU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 15:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbYHPTwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 15:52:54 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:62932 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752336AbYHPTwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 15:52:53 -0400
Date: Sat, 16 Aug 2008 20:52:07 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] x86: apic - unify lapic_resume
In-Reply-To: <722b5bc0303212ca203cadeedae5ede3e23eccb7.1218914042.git.gorcunov@gmail.com>
Message-ID: <Pine.LNX.4.55.0808162041190.17944@cliff.in.clinika.pl>
References: <1218914515-26377-1-git-send-email-gorcunov@gmail.com>
 <f87881899957b7aa08b827cdc6b5dd8cf53e4730.1218914042.git.gorcunov@gmail.com>
 <722b5bc0303212ca203cadeedae5ede3e23eccb7.1218914042.git.gorcunov@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Aug 2008, Cyrill Gorcunov wrote:

> +#ifdef CONFIG_X86_64
> +	if (x2apic)
> +		enable_x2apic();
> +	else
> +#endif

 Hmm, x86-64 hardware can run a 32-bit kernel, so it might be a good idea
to take the opportunity of the merge and extend x2APIC support to the
32-bit configuration too.  It should be mostly a mechanical change.  Just
a suggestion though -- feel free to ignore if you'd rather not dive into
it. ;)

  Maciej
