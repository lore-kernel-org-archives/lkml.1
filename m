Return-Path: <linux-kernel-owner+w=401wt.eu-S1754857AbYDILfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbYDILfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 07:35:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbYDILe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 07:34:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40003 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525AbYDILe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 07:34:56 -0400
Date: Wed, 9 Apr 2008 13:34:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jacek Luczak <difrost.kernel@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: linux-next: Tree for April 9
Message-ID: <20080409113439.GA26174@elte.hu>
References: <20080409185309.b94c9d15.sfr@canb.auug.org.au> <d711229d0804090400p1c92a158j381b86e207a6f38a@mail.gmail.com> <20080409210936.ec8ea986.sfr@canb.auug.org.au> <20080409212719.7d834c13.sfr@canb.auug.org.au> <47FCA7FA.3010008@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47FCA7FA.3010008@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Jacek Luczak <difrost.kernel@gmail.com> wrote:

>> Don't worry about it, I found the problem.
>>
>> It seems that commit 883a9fc4e5d9b0701f15d4e5a23608f942104721 ("x86: 
>> cleanup - rename VM_MASK to X86_VM_MASK") from the x86 tree seems to 
>> have missed some places.
>
> Yep, I did the same. You can find patch, which renames changes VM_MASK 
> to X86_VM_MASK across all files in arch/x86/kernel, here: 
> http://pin.if.uz.zgora.pl/~difrost/linux-next/09042008/

ah, that again comes from x86/for-akpm missing a patch that comes later 
in x86/latest. I'll resort it.

	Ingo
