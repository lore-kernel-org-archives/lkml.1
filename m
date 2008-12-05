Return-Path: <linux-kernel-owner+w=401wt.eu-S1753106AbYLEID4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbYLEID4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 03:03:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750839AbYLEIDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 03:03:47 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:42792 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbYLEIDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 03:03:47 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [patch 0/3] [Announcement] Performance Counters for Linux
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Miller <davem@davemloft.net>
In-Reply-To: <18744.57057.243817.407691@cargo.ozlabs.ibm.com>
References: <20081204225345.654705757@linutronix.de>
	 <18744.29747.728320.652642@cargo.ozlabs.ibm.com>
	 <20081205063131.GB12785@elte.hu> <20081205070329.GA30874@elte.hu>
	 <1228461385.18899.13.camel@twins>
	 <18744.57057.243817.407691@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Fri, 05 Dec 2008 09:03:36 +0100
Message-Id: <1228464216.18899.18.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-12-05 at 18:57 +1100, Paul Mackerras wrote:
> Peter Zijlstra writes:
> 
> > So, while most people would not consider two consecutive read() ops to
> > be close or near the same time, due to preemption and such, that is
> > taken away by the fact that the counters are task local time based - so
> > preemption doesn't affect thing. Right?
> 
> I'm sorry, I don't follow the argument here.  What do you mean by
> "task local time based"?

time only flows when the task is running.


