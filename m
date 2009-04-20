Return-Path: <linux-kernel-owner+w=401wt.eu-S1754271AbZDTRV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbZDTRV1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 13:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbZDTRVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 13:21:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51960 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644AbZDTRVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 13:21:16 -0400
Date: Mon, 20 Apr 2009 19:20:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Brian Maly <bmaly@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, h.peter.anvin@intel.com,
       linux-kernel@vger.kernel.org, dannf@hp.com, ying.huang@intel.com
Subject: Re: [PATCH] rtc: add x86 support for rtc-efi
Message-ID: <20090420172045.GA17887@elte.hu>
References: <49DA40B9.2060804@redhat.com> <49DA817E.8040705@intel.com> <49DA8875.5050009@redhat.com> <20090409161803.f79c0b64.akpm@linux-foundation.org> <20090410135102.GB24809@elte.hu> <49ECADAB.4020609@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49ECADAB.4020609@redhat.com>
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


* Brian Maly <bmaly@redhat.com> wrote:

>> Hm, it would be nice to first unify the relevant bits of 
>> arch/x86/kernel/time_{32|64}.c into arch/x86/kernel/time.c, and 
>> then we can apply such patches without duplicative effects.
>
> Ingo,
>
> Are you OK with consolidating this into arch/x86/kernel/rtc.c as 
> Huang Ying had suggested? This seems like the most logical place 
> for the rtc-efi init to happen, but your suggestion to consolidate 
> this into arch/x86/kernel.time.c may have advantages that I am not 
> aware of.  Anyway, I would appreciate any insight/opinions on this 
> if you have any.  Thanks.

Yes, that indeed sounds like an even better place for it.

Thanks,

	Ingo
