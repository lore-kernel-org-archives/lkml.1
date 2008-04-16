Return-Path: <linux-kernel-owner+w=401wt.eu-S1762056AbYDPIY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762056AbYDPIY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 04:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754065AbYDPIYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 04:24:14 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:24469 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605AbYDPIYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 04:24:11 -0400
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "Adam J. Richter" <adam@yggdrasil.com>,
       Alexander Kjeldaas <astor@fast.no>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de
Subject: Re: [PATCH -mm crypto] AES: x86_64 asm implementation optimization
From: Andi Kleen <andi@firstfloor.org>
References: <1207723262.18313.37.camel@caritas-dev.intel.com>
	<20080416073108.GA13494@Chamillionaire.breakpoint.cc>
	<1208333949.4322.5.camel@caritas-dev.intel.com>
Date: Wed, 16 Apr 2008 10:23:04 +0200
In-Reply-To: <1208333949.4322.5.camel@caritas-dev.intel.com> (Ying Huang's message of "Wed, 16 Apr 2008 16:19:09 +0800")
Message-ID: <87r6d65huf.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 16 Apr 2008 08:16:18.0211 (UTC) FILETIME=[2572A730:01C89F9A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Huang, Ying" <ying.huang@intel.com> writes:
>
> En. I have no AMD machine. So I have not tested the patch on it. Maybe
> there are some pipeline or load/store unit difference between Intel and
> AMD CPUs. Tomorrow I can split the patch into a set of small patches,
> with one patch for one small step. Can you help me to test these patches
> to find out the reason for degradation on AMD CPU.

It would be also quite possible to use two different implementations,
one for AMD another for Intel.  crypto frame work should have no
problems dealing with that.

-Andi
