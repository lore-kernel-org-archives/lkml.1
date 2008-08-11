Return-Path: <linux-kernel-owner+w=401wt.eu-S1754528AbYHKRoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbYHKRoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 13:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbYHKRoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 13:44:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44657 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbYHKRoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 13:44:11 -0400
Date: Mon, 11 Aug 2008 19:43:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mingo@redhat.com" <mingo@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 0/3] make swiotlb prototypes generic
Message-ID: <20080811174349.GP4524@elte.hu>
References: <1218114409-20806-1-git-send-email-joerg.roedel@amd.com> <57C9024A16AD2D4C97DC78E552063EA3083841F6@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA3083841F6@orsmsx505.amr.corp.intel.com>
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


* Luck, Tony <tony.luck@intel.com> wrote:

> > this small series of patches introduce a generic header file for the software
> > IO/TLB implementation in lib/swiotlb.c. Currently each architecture using this
> > code defines the prototypes itself. The prototypes are moved to
> > include/linux/swiotlb.h and this file is included in architecture specific code
> > for X86 and IA64. The changes are compile tested for both architectures.
> 
> Boot tested on ia64 (using generic_defconfig, tiger_defconfig and 
> zx1_defconfig).

given that this touches both x86 and ia64, i suspect queueing it in -mm 
(as it is already) and merging it upstream from there would be the best 
approach?

	Ingo
