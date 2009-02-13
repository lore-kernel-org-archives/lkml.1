Return-Path: <linux-kernel-owner+w=401wt.eu-S1759174AbZBMQZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759174AbZBMQZl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 11:25:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbZBMQZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 11:25:34 -0500
Received: from gw.goop.org ([64.81.55.164]:36479 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350AbZBMQZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 11:25:33 -0500
Message-ID: <49959EFA.8040507@goop.org>
Date: Fri, 13 Feb 2009 08:25:30 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86 headers: include linux/types.h
References: <49935DD8.8010705@goop.org> <20090213120239.GL15679@elte.hu> <20090213121858.GB5483@elte.hu> <20090213122325.GA30061@elte.hu> <20090213122724.GA2172@elte.hu>
In-Reply-To: <20090213122724.GA2172@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Regarding the fixlet below - wouldnt PTE_FLAGS_MASK be better placed in
> pgtable_types.h ? It's specifically related to the pte format. OTOH we
> have a lot of PTE details in the page_*types.h files already.
>   

No, you're right.

> The boundary between page_types.h and pgtable_types.h does not seem to
> be clear to me - what is the principle you followed?
>   

Well, basically anything to do with the internals of a pte*_t go in 
pgtable.h.  PTE_*_MASK should go there too, and is an oversight (though 
its on the margin because of its dependency on the page size/mask 
definitions in page*.h).

    J
