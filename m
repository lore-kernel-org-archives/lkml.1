Return-Path: <linux-kernel-owner+w=401wt.eu-S1758655AbZBMSJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655AbZBMSJn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 13:09:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750775AbZBMSJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 13:09:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33280 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbZBMSJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 13:09:35 -0500
Date: Fri, 13 Feb 2009 19:09:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86 headers: include linux/types.h
Message-ID: <20090213180924.GD18581@elte.hu>
References: <49935DD8.8010705@goop.org> <20090213120239.GL15679@elte.hu> <20090213121858.GB5483@elte.hu> <20090213122325.GA30061@elte.hu> <20090213122724.GA2172@elte.hu> <49959EFA.8040507@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49959EFA.8040507@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
>> Regarding the fixlet below - wouldnt PTE_FLAGS_MASK be better placed in
>> pgtable_types.h ? It's specifically related to the pte format. OTOH we
>> have a lot of PTE details in the page_*types.h files already.
>>   
>
> No, you're right.
>
>> The boundary between page_types.h and pgtable_types.h does not seem to
>> be clear to me - what is the principle you followed?
>>   
>
> Well, basically anything to do with the internals of a pte*_t go in  
> pgtable.h.  PTE_*_MASK should go there too, and is an oversight (though  
> its on the margin because of its dependency on the page size/mask  
> definitions in page*.h).

likewise, PUD_PAGE_* and PAGETABLE_LEVELS should move to pgtable_types.h
too i guess. Same goes for *MASK_SHIFT*.

	Ingo
