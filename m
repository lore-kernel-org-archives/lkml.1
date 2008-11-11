Return-Path: <linux-kernel-owner+w=401wt.eu-S1755902AbYKKKhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbYKKKhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 05:37:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754974AbYKKKhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 05:37:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54852 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754895AbYKKKhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 05:37:03 -0500
Date: Tue, 11 Nov 2008 11:36:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rufus & Azrael <rufus-azrael@numericable.fr>
Cc: Rakib Mullick <rakib.mullick@gmail.com>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86: Fixing improper annotation.
Message-ID: <20081111103649.GA10554@elte.hu>
References: <49193D1A.9040000@numericable.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49193D1A.9040000@numericable.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0729]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rufus & Azrael <rufus-azrael@numericable.fr> wrote:

> Hi Rakib,
>
>
> Your two patches set for x86 init_thread_xsate function section 
> mismatch is correct to fix the compilation warning, but generates 
> this other one :
>
>> WARNING: vmlinux.o(.cpuinit.text+0x7de): Section mismatch in reference  
>> from the function xsave_cntxt_init() to the function  
>> .init.text:__alloc_bootmem()
>> The function __cpuinit xsave_cntxt_init() references
>> a function __init __alloc_bootmem().
>> If __alloc_bootmem is only used by xsave_cntxt_init then
>> annotate __alloc_bootmem with a matching annotation.

that's with both 1/2 and 2/2 applied?

	Ingo
