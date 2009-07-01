Return-Path: <linux-kernel-owner+w=401wt.eu-S1754245AbZGANWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245AbZGANWd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 09:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbZGANWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 09:22:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56541 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555AbZGANWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 09:22:23 -0400
Date: Wed, 1 Jul 2009 15:22:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip RESEND] x86: amd_iommu.c device_nb should be static
Message-ID: <20090701132219.GC13524@elte.hu>
References: <1246450627.6940.6.camel@hpdv5.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246450627.6940.6.camel@hpdv5.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0008]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> 
> device_nb is used only by same file, it should be static.
> 
> Also fixed NULL pointer issue.
> 
> Fixed following sparse warnings :
>   arch/x86/kernel/amd_iommu.c:1195:23: warning: symbol 'device_nb' was not declared. Should it be static?
>   arch/x86/kernel/amd_iommu.c:1766:10: warning: Using plain integer as NULL pointer

Mind resending this with a proper changelog, along the template of:

|  This Sparse warning:
|
|      arch/x86/kernel/amd_iommu.c...
|
|  triggers because <reason>. <do action> to fix that - this also
|  addresses the Sparse warning.

Where, in this current case:

 <reason>    := device_nb is global but is only used in a single .c file
 <do action> := change device_nb to static

Please fill in the reason and action for the NULL fix as well.

Please write all similar warning fix commit log messages in a 
similar way in the future if you want me to apply them.

Thanks,

	Ingo
