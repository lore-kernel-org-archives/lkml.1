Return-Path: <linux-kernel-owner+w=401wt.eu-S1756206AbYFYCYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbYFYCYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 22:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752328AbYFYCYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 22:24:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49714 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbYFYCYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 22:24:02 -0400
Message-ID: <4861AAEF.3020103@zytor.com>
Date: Tue, 24 Jun 2008 19:18:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: yhlu.kernel@gmail.com, akpm@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, steiner@sgi.com, travis@sgi.com,
       linux-kernel@vger.kernel.org, ying.huang@intel.com, andi@firstfloor.org
Subject: Re: [PATCH 4/5 v2] x86 boot: show pfn addresses in hex not decimal
 in some kernel info printks
References: <20080622142151.5591.4139.sendpatchset@polaris-admin.engr.sgi.com>	<20080622142212.5591.64592.sendpatchset@polaris-admin.engr.sgi.com>	<86802c440806221238g78300952t2fc7f406c1842273@mail.gmail.com>	<20080623060939.6b6b3183.pj@sgi.com>	<86802c440806241429s7f5e899dn67d42303247f618@mail.gmail.com>	<20080624203252.f932c631.pj@sgi.com>	<4861A5DF.5010104@zytor.com> <20080624211711.8c6d5105.pj@sgi.com>
In-Reply-To: <20080624211711.8c6d5105.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> hpa wrote:
>> that would have to be %#10lx.
> 
> Hmmm ... the '#' is a good idea, instead of an explicit "0x".
> 
> Do we want zero padding as well, with "0#8lx" ?
> 
> Zone PFN ranges:
>   DMA      0x00000000 -> 0x00001000
>   DMA32    0x00001000 -> 0x00100000
>   Normal   0x00100000 -> 0x00428000
> 
> or right aligned, space padded:
> 
> Zone PFN ranges:
>   DMA             0x0 ->     0x1000
>   DMA32        0x1000 ->   0x100000
>   Normal     0x100000 ->   0x428000
> 
> I like the zero padding here myself.
> 

Yes, zero padding.

What we really should have is %p produce this format.  For some odd 
reason, right now %p produces numbers without the 0x prefix.

	-h
