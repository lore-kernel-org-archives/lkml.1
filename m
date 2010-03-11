Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab0CKVoU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 16:44:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:51536 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754574Ab0CKVoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 16:44:19 -0500
Message-ID: <4B9963D2.10002@kernel.org>
Date: Thu, 11 Mar 2010 13:42:42 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Greg Thelen <gthelen@google.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, cl@linux-foundation.com
Subject: Re: mmotm boot panic bootmem-avoid-dma32-zone-by-default.patch
References: <49b004811003041321g2567bac8yb73235be32a27e7c@mail.gmail.com> <20100305032106.GA12065@cmpxchg.org> <4B90C921.6060908@kernel.org> <4B90DC3C.1060000@gmail.com> <4B92FE9E.90600@kernel.org> <4B98CBC8.6080008@gmail.com> <4B994EC4.2050705@kernel.org> <4B996335.7070907@gmail.com>
In-Reply-To: <4B996335.7070907@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2010 01:40 PM, Jiri Slaby wrote:
> On 03/11/2010 09:12 PM, Yinghai Lu wrote:
>> On 03/11/2010 02:54 AM, Jiri Slaby wrote:
>>> Hi, yes, it is 2.6.27.
>>
>> SLES 11?
> 
> Sorry I wrote that in haste. It is SLES 10 in the end. That means it is
> 2.6.16, not 2.6.27. Hence no sparsemem whatsoever. With SLES11 it should
> be OK, we are using flatmem only for i386.
> 
> Whatever, it should be no issue now, as flatmem currently (as of 2.6.25)
> depends on i386.
> 
> On the other hand I still considered the patch as applicable to
> contemporary kernels since there might be weird bios e820 maps and huge
> (and sparse) bootmem allocations/reservations (memory cgroups, initrd)
> so that code requiring much memory below 4g (swiotlb) will fail then.
> 
> Whatever, in the current kernel, the particular issue I was referring to
> *is not reproducible*.

the point is: we should only put the memmap put high. that is big chunk...
other users should be ok... and leave them alone. 

YH
