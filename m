Return-Path: <linux-kernel-owner+w=401wt.eu-S1751962AbZGYRla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbZGYRla (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 13:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbZGYRla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 13:41:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:39033 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbZGYRl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 13:41:29 -0400
Subject: Re: [PATCH] sched: Provide iowait counters
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>
In-Reply-To: <4A6B35F7.2030804@linux.intel.com>
References: <4A64B813.1080506@linux.intel.com>
	 <20090724212220.afa278ee.akpm@linux-foundation.org>
	 <4A6A8AFE.1010608@linux.intel.com>
	 <20090724214006.7380c3b4.akpm@linux-foundation.org>
	 <4A6A8E96.7050509@linux.intel.com>
	 <20090724220423.11828b85.akpm@linux-foundation.org>
	 <1248501946.6987.146.camel@twins>
	 <20090725002148.5524c846.akpm@linux-foundation.org>
	 <4A6B35F7.2030804@linux.intel.com>
Content-Type: text/plain
Date: Sat, 25 Jul 2009 19:41:14 +0200
Message-Id: <1248543674.5780.36.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-07-25 at 09:42 -0700, Arjan van de Ven wrote:
> 
> In case you wonder why you need both tools, and can't just use one: we
> wondered the same, but it turns out that if you only build
> Tool Two, you don't get a good overview of what is going on on a
> higher level. It's like looking at the world via a microscope all the
> time,

I'd be thinking you could compose your ms based picture on the sample
data. For instance, if you sample on cpu-clock at 100kHz, then a 100
samples get you a full blue slice, 50 get you a 50% blue slice, etc.

Of course, since its sample based, you can miss some detail, but I think
you're looking at the large picture anyway.

Would this work?

