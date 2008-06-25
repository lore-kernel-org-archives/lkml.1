Return-Path: <linux-kernel-owner+w=401wt.eu-S1754309AbYFYB5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309AbYFYB5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 21:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754943AbYFYB5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 21:57:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36708 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825AbYFYB5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 21:57:34 -0400
Message-ID: <4861A5DF.5010104@zytor.com>
Date: Tue, 24 Jun 2008 18:56:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, akpm@linux-foundation.org,
       mingo@elte.hu, tglx@linutronix.de, steiner@sgi.com, travis@sgi.com,
       linux-kernel@vger.kernel.org, ying.huang@intel.com, andi@firstfloor.org
Subject: Re: [PATCH 4/5 v2] x86 boot: show pfn addresses in hex not decimal
 in some kernel info printks
References: <20080622142151.5591.4139.sendpatchset@polaris-admin.engr.sgi.com>	<20080622142212.5591.64592.sendpatchset@polaris-admin.engr.sgi.com>	<86802c440806221238g78300952t2fc7f406c1842273@mail.gmail.com>	<20080623060939.6b6b3183.pj@sgi.com>	<86802c440806241429s7f5e899dn67d42303247f618@mail.gmail.com> <20080624203252.f932c631.pj@sgi.com>
In-Reply-To: <20080624203252.f932c631.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Yinghai wrote:
>> Zone PFN ranges:
>>   DMA      0x       0 -> 0x    1000
> 
> Aha - you're right!
> 
> I just earned the Ugly Patch of the Day Award.
> 
> I think changes of "%lu" to "0x%lx" are still ok,
> but changes of "%8lu" to "0x%8lx" (which use 8
> columns, right aligned, space filled format) are
> not ok.
> 

No, that would have to be %#10lx.

	-hpa
