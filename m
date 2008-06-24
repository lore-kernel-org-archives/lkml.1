Return-Path: <linux-kernel-owner+w=401wt.eu-S1759909AbYFXLTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759909AbYFXLTo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 07:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758666AbYFXLT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 07:19:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56824 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757797AbYFXLT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 07:19:26 -0400
Date: Tue, 24 Jun 2008 13:19:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Jackson <pj@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Jack Steiner <steiner@sgi.com>, Mike Travis <travis@sgi.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       "Huang, Ying" <ying.huang@intel.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/5 v2] x86 boot: various E820 & EFI related fixes -
	what changed in v2
Message-ID: <20080624111903.GD8695@elte.hu>
References: <20080622142151.5591.4139.sendpatchset@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080622142151.5591.4139.sendpatchset@polaris-admin.engr.sgi.com>
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

> The following patches differ from their previous versions,
> submitted a week ago, on the evening of Sun, 15 Jun 2008,
> in the following ways:
>  1) The "x86_64 build reserve_bootmem_generic fix" patch
>     is dropped, because it is already fixed in linux-next.
>     Thanks to Yinghai Lu.
>  2) The "allow overlapping ebda and efi memmap memory ranges"
>     patch is reworked.  Instead of allowing overlapping early
>     memory reservations on EFI boots, rather it allows
>     particular early memory reservations to overlap, if they
>     have been so marked.  Only the EBDA "BIOS reserved"
>     reservation is so marked for now; only it can overlap.
>     Thanks to H. Peter Anvin and Huang Ying.
>  3) The patches "remap efi systab runtime from phys to virt"
>     and "virtualize the efi runtime function callback addresses"
>     are dropped.  They were incorrect.  I fixed my EFI firmware
>     to follow the spec instead.  Thanks to Huang Ying.

applied to tip/x86/setup-memory, thanks Paul.

( the review feedback from Peter still needs to be addressed before the
  memmap-from-EFI portion of your changes can be considered for
  upstream. See http://lkml.org/lkml/2008/6/24/26. Should be pretty
  straightforward. )

	Ingo
