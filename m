Return-Path: <linux-kernel-owner+w=401wt.eu-S1756687AbZANIxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbZANIxw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 03:53:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760732AbZANIxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 03:53:39 -0500
Received: from one.firstfloor.org ([213.235.205.2]:55905 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759596AbZANIxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 03:53:38 -0500
Date: Wed, 14 Jan 2009 10:08:11 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Ravikiran G Thirumalai <kiran@scalex86.org>,
       Frederik Deweerdt <frederik.deweerdt@xprog.eu>, andi@firstfloor.org,
       tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] tlb flush_data: replace per_cpu with an array
Message-ID: <20090114090811.GQ23848@one.firstfloor.org>
References: <20090112213539.GA10720@gambetta> <20090112223421.GA20594@localdomain> <20090112230052.GB18771@elte.hu> <1231848016.442.112.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231848016.442.112.camel@twins>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > It also would save some memory
> > on most distros out there (Ubuntu x86_64 has NR_CPUS=64 by default).

As pointed out several times this claim in the changelog is incorrect.
Please fix it.

A correct description would be:

- This patch wastes memory of one configured cache line for each CPU 
on systems with less than 8 cores (e.g. 896 bytes on a 1 core system
with CONFIG_GENERIC_CPU/ cache line size 128)
It saves some memory on systems with more than 8 cores (one cache
line size for each core above 8)

-Andi

