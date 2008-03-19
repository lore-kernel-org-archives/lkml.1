Return-Path: <linux-kernel-owner+w=401wt.eu-S1755016AbYCSWW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016AbYCSWW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935826AbYCSVAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:00:12 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:55963 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935827AbYCSVAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:00:06 -0400
Date: Wed, 19 Mar 2008 16:13:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, andi@firstfloor.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: iommu: it could use some documentation
Message-ID: <20080319151346.GA28798@elte.hu>
References: <20080319145811.GA27113@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080319145811.GA27113@elf.ucw.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0155]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@ucw.cz> wrote:

> Fix coding style in pci-dma_64.c and add stubs for documentation. I 
> hope someone fills the rest, I understand maybe off and soft...

> +	iommu=		[x86]
> +		off
> +		force
> +		noforce
> +		biomerge
> +		panic
> +		nopanic
> +		merge
> +		nomerge
> +		forcesac
> +		soft

these are mostly quirks to get boards booting - few people use these for 
performance tuning. SAC has an address space limit (40 bits) but is 
faster, DAC can cover the physical address range but is slower. The 
softiotlb we better forget about ;-)

if you are interested in fixing this, the descriptions from 
Documentation/x86_64/boot-options.txt should/could be merged into 
Documentation/kernel-parameters.txt.

	Ingo
