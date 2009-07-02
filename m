Return-Path: <linux-kernel-owner+w=401wt.eu-S1756288AbZGBHIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288AbZGBHIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 03:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbZGBHHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 03:07:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41039 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380AbZGBHHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 03:07:44 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kevin Cernekee <cernekee@gmail.com>, <linux-kernel@vger.kernel.org>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH] Fix virt_to_phys() warnings
From: Andi Kleen <andi@firstfloor.org>
References: <910ba280decc9ee53d9971ba04f73fab@localhost>
	<20090701224627.0b2704df.akpm@linux-foundation.org>
Date: Thu, 02 Jul 2009 09:07:46 +0200
In-Reply-To: <20090701224627.0b2704df.akpm@linux-foundation.org> (Andrew Morton's message of "Wed, 1 Jul 2009 22:46:27 -0700")
Message-ID: <87bpo3bm0t.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:
>
> #define virt_to_page(kaddr)        pfn_to_page(PFN_DOWN(virt_to_phys(kaddr)))
>
> thereby passing an `unsigned long' where a void* was expected.
>
>
> So perhaps something along these lines:

I'm not quite sure it's the case on MIPS, but I remember on x86 one of
the reasons this was done as a macro was to avoid a include dependency
loop with struct page.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
