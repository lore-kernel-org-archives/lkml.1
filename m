Return-Path: <linux-kernel-owner+w=401wt.eu-S1753135AbYBROGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbYBROGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 09:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751610AbYBROGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 09:06:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54641 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbYBROGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 09:06:08 -0500
Date: Mon, 18 Feb 2008 15:05:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Huang, Ying" <ying.huang@intel.com>, torvalds@osdl.org,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix left over EFI cache mapping problems
Message-ID: <20080218140546.GA462@elte.hu>
References: <20080214131317.GA27769@basil.nowhere.org> <20080214161218.GA28152@elte.hu> <1203050886.30010.19.camel@caritas-dev.intel.com> <20080215070843.GA6975@elte.hu> <1203299636.27509.14.camel@caritas-dev.intel.com> <20080218112621.GA24147@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080218112621.GA24147@one.firstfloor.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> > UEFI specification 2.1 (section 6.2, page 124) that the 
> > NumberOfPages (num_pages) of EFI_MEMORY_DESCRIPTOR 
> > (efi_memory_desc_t) must be "Number of 4KB pages in the memory 
> > region". So we need not worry about potential EFI_PAGE_SHIFT 
> > changes.
> 
> Then it would be cleaner to just use PAGE_SIZE in the x86 specific EFI 
> code imho.

(as i suggested in the mail Ying replied to.)

But ... as long as ia64 uses EFI too i dont mind if it's using 
EFI_PAGE_SHIFT consistently, even in the arch/x86-only files.

	Ingo
