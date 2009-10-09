Return-Path: <linux-kernel-owner+w=401wt.eu-S934038AbZJIRuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934038AbZJIRuL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 13:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933782AbZJIRuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 13:50:10 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48934 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933451AbZJIRuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 13:50:09 -0400
Date: Fri, 9 Oct 2009 19:49:29 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [rfc][patch] store-free path walking
Message-ID: <20091009174929.GD1656@one.firstfloor.org>
References: <alpine.LFD.2.01.0910070742260.3432@localhost.localdomain> <alpine.LFD.2.01.0910070911080.3432@localhost.localdomain> <20091007164622.GX30316@wotan.suse.de> <alpine.LFD.2.01.0910071222230.3432@localhost.localdomain> <87eipfymcv.fsf@basil.nowhere.org> <alpine.LFD.2.01.0910071349190.3432@localhost.localdomain> <20091007210651.GB1656@one.firstfloor.org> <alpine.LFD.2.01.0910071417300.3432@localhost.localdomain> <alpine.LFD.2.01.0910071450510.3432@localhost.localdomain> <1158166a0910080612h29d93d50y875d5305cd4d985f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1158166a0910080612h29d93d50y875d5305cd4d985f@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> A few years ago when K7s were not ancient yet, after hearing
> argument for and against non-temporal stores,
> I decided to finally figure it for myself.
> 
> I tested kernel build workload on two kernels with the only
> one difference - clear_page with and without non-temporal stores.
> 
> "Non-temporal stores" kernel was faster, not slower. Just a little bit,
> but reproducibly.

I did the same experiments and in my case (K8) they were slower in 
real-world benchmarks for clear_page (but faster in micro benchmarks)

But I didn't propose non temporal anyways.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
