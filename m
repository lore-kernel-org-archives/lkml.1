Return-Path: <linux-kernel-owner+w=401wt.eu-S1759029AbYLPUv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759029AbYLPUv0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 15:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754821AbYLPUu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 15:50:56 -0500
Received: from smtpauth00.csee.onr.siteprotect.com ([64.26.60.144]:44303 "EHLO
	smtpauth00.csee.onr.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754527AbYLPUuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 15:50:55 -0500
Date: Tue, 16 Dec 2008 15:55:41 -0500 (EST)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       perfctr-devel@lists.sourceforge.net
Subject: Re: [patch] Performance Counters for Linux, v4
In-Reply-To: <494805E4.2040008@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.64.0812161552460.7050@pianoman.cluster.toy>
References: <20081214212829.GA9435@elte.hu> <Pine.LNX.4.64.0812161232170.6249@pianoman.cluster.toy>
 <494805E4.2040008@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2008, Corey Ashford wrote:
> In common with both perfmon3 and Ingo's solution is that as more and more 
> events are scheduled onto the same set of hardware registers, the accuracy 
> drops and has to be compensated with longer run times.

There seems to be some confusion.

I want aggregate instruction count.  I do not want any sort of scaling or 
sampling.

When I cound retired instructions and cycles, I want the full counts for 
those.  The q6600 definitely has more than 2 counters available, so it 
should be able to give me exact aggregate counts for those counters.  No 
sampling or scaling should be involved.

Is it not possible to get raw, aggregate count with Ingo's infrastructure? 
The documentation is vague on this.

Vince

