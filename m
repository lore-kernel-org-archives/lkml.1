Return-Path: <linux-kernel-owner+w=401wt.eu-S1760590AbZAWSag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760590AbZAWSag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 13:30:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279AbZAWSa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 13:30:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60350 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241AbZAWSa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 13:30:28 -0500
Date: Fri, 23 Jan 2009 19:30:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: inline asm semantics: output constraint width smaller than
	input
Message-ID: <20090123183019.GA5984@elte.hu>
References: <497A0500.3080706@gmail.com> <20090123181721.GA32545@elte.hu> <497A0C0A.7080207@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <497A0C0A.7080207@gmail.com>
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


* Török Edwin <edwintorok@gmail.com> wrote:

> Having said that, llvm-gcc is not yet able to compile the full Linux 
> kernel on its own [for example the boot code, due to asm(".code16gcc")], 
> but with LLVM 2.4 it was possible to build "arch=UM", and "arch=X86" (by 
> using gcc to build the bootcode). I'd like LLVM 2.5 to be able to build 
> the kernel, so I'll file bugs for llvm/kernel depending on where the 
> problem is.

Could we get LLVM folks on the Cc: and see how difficult it would be to 
fix this on the LLVM side? Asm constraints are used all around the place 
and different input/output types are very common.

	Ingo
