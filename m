Return-Path: <linux-kernel-owner+w=401wt.eu-S1760642AbZEZWxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760642AbZEZWxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 18:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759253AbZEZWxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 18:53:05 -0400
Received: from www.tglx.de ([62.245.132.106]:54231 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756253AbZEZWxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 18:53:05 -0400
Date: Wed, 27 May 2009 00:52:32 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       lkml <linux-kernel@vger.kernel.org>, john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH] x86: fix cpufreq tsc scaling
In-Reply-To: <1243378105.6600.28.camel@laptop>
Message-ID: <alpine.LFD.2.00.0905270050460.1762@localhost.localdomain>
References: <1243378105.6600.28.camel@laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009, Peter Zijlstra wrote:
> Subject: x86: fix cpufreq tsc scaling
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Wed May 27 00:32:23 CEST 2009
> 
> For freqency dependent TSCs we only scale the cycles, we do not account
> for the discrepancy in absolute value. Add a constant factor so that:
> 
>   c1 + f1*cyc == c2 + f2*cyc
> 
> LKML-Reference: <new-submission>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Chucked-on-by: Thomas Gleixner <tglx@linutronix.de>

Hey, you misspelled this. I said "Chuckled-on-by"

     tglx
