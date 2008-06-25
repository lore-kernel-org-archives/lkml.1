Return-Path: <linux-kernel-owner+w=401wt.eu-S1759700AbYFYQLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759700AbYFYQLl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 12:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbYFYQLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 12:11:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59041 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446AbYFYQLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 12:11:33 -0400
Date: Wed, 25 Jun 2008 18:11:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Jackson <pj@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Jack Steiner <steiner@sgi.com>, Mike Travis <travis@sgi.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       "Huang, Ying" <ying.huang@intel.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 2/2] x86 boot: only pick up additional EFI memmap if
	add_efi_memmap flag
Message-ID: <20080625161101.GD24967@elte.hu>
References: <20080625124440.25036.96518.sendpatchset@polaris-admin.engr.sgi.com> <20080625124446.25036.25226.sendpatchset@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080625124446.25036.25226.sendpatchset@polaris-admin.engr.sgi.com>
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


* Paul Jackson <pj@sgi.com> wrote:

> From: Paul Jackson <pj@sgi.com>
> 
> Applies on top of the previous patch:
>   x86 boot: add code to add BIOS provided EFI memory entries to kernel
> 
> Instead of always adding EFI memory map entries (if present) to the 
> memory map after initially finding either E820 BIOS memory map entries 
> and/or kernel command line memmap entries, -instead- only add such 
> additional EFI memory map entries if the kernel boot option:
> 
>     add_efi_memmap
> 
> is specified.
> 
> Requiring this 'add_efi_memmap' option is backward compatible with 
> kernels that didn't load such additional EFI memory map entries in the 
> first place, and it doesn't override a configuration that tries to 
> replace all E820 or EFI BIOS memory map entries with ones given 
> entirely on the kernel command line.

applied to tip/x86/setup-memory - thanks Paul.

	Ingo
