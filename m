Return-Path: <linux-kernel-owner+w=401wt.eu-S1755533AbXGAWCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbXGAWCi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 18:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbXGAWC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 18:02:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:43130 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115AbXGAWC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 18:02:29 -0400
From: Andreas Schwab <schwab@suse.de>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [i386] Questions regarding provisional page tables initialization
References: <20070701203833.GA3498@Ahmed>
X-Yow: Hello, GORRY-O!!  I'm a GENIUS from HARVARD!!
Date: Mon, 02 Jul 2007 00:02:27 +0200
In-Reply-To: <20070701203833.GA3498@Ahmed> (Ahmed S. Darwish's message of
	"Sun\, 1 Jul 2007 23\:38\:33 +0300")
Message-ID: <jed4zbeqa4.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Ahmed S. Darwish" <darwish.07@gmail.com> writes:

>         page_pde_offset = (__PAGE_OFFSET >> 20)
> 	movl %ecx,(%edx)			/* Store identity PDE entry */
> 	movl %ecx,page_pde_offset(%edx)		/* Store kernel PDE entry */
>
> Why the pde_offset is PAGE_OFFSET >> 20 instead of PAGE_OFFSET >> 22 ?
> * 22 to right shift the whole page_shift (12) and pgdir_shift (10) bits.

4 is the element size.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
