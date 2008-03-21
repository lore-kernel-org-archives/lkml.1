Return-Path: <linux-kernel-owner+w=401wt.eu-S1757459AbYCUNLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459AbYCUNLU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 09:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755122AbYCUNLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 09:11:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46756 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755115AbYCUNLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 09:11:10 -0400
Date: Fri, 21 Mar 2008 14:10:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-arch <linux-arch@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [0/3] Improve generic fls64 for 64-bit machines
Message-ID: <20080321131046.GG27245@elte.hu>
References: <20080315172913.GA21648@mailshack.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080315172913.GA21648@mailshack.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0395]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander van Heukelum <heukelum@mailshack.com> wrote:

> This series of patches:
> 
> [1/3] adds __fls.h to asm-generic
> [2/3] modifies asm-*/bitops.h for 64-bit archs to implement __fls
> [3/3] modifies asm-generic/fls64.h to make use of __fls
> 
> I have compiled i386 and x86_64, and they generate the same code as 
> before the change. The changes to the other archs are a best effort. 
> Please comment.

i've applied #1 and #3 to x86.git/testing, to see how this works out on 
x86. But it looks good to me in general.

	Ingo
