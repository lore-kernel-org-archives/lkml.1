Return-Path: <linux-kernel-owner+w=401wt.eu-S1757956AbYLLLgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956AbYLLLgW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 06:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbYLLLgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 06:36:14 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:46877 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbYLLLgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 06:36:13 -0500
X-BigFish: VPS-42(zz1432R62a3L98dR936eQ1805M936fOzzzzz32i6bh43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KBRHJZ-01-33K-01
Date: Fri, 12 Dec 2008 12:35:20 +0100
From: Robert Richter <robert.richter@amd.com>
To: Christoph Hellwig <hch@infradead.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, eranian@gmail.com,
       Vince Weaver <vince@deater.net>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch] Performance Counters for Linux, v3
Message-ID: <20081212113520.GF30490@erda.amd.com>
References: <20081211155230.GA4230@elte.hu> <Pine.LNX.4.64.0812111247510.22556@pianoman.cluster.toy> <1229070345.12883.12.camel@twins> <7c86c4470812120059s7f8e64a6h91ebeadbf938858d@mail.gmail.com> <1229073834.12883.41.camel@twins> <20081212102111.GE30490@erda.amd.com> <20081212105938.GA2685@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081212105938.GA2685@infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 12 Dec 2008 11:36:01.0510 (UTC) FILETIME=[CF30F860:01C95C4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.12.08 05:59:38, Christoph Hellwig wrote:
> On Fri, Dec 12, 2008 at 11:21:11AM +0100, Robert Richter wrote:
> > I agree with Stephane. There are already many different PMU
> > descriptions depending on family, model and steppping and with *every*
> > new cpu revision you will get one more update. Implementing this in
> > the kernel would require kernel updates where otherwise no changes
> > would be necessary.
> 
> Please stop the Bullshit.  You have to update _something_.  It makes a
> lot of sense to update the thing you need to udpate anyway for new
> hardware support, and not some piece of junk library like libperfmon.

New hardware does not always mean to implement new hardware
support. Sometimes it is sufficient to simply program the same
registers in another way. Why changing the kernel for this?

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

