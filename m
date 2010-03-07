Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab0CGBSh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 20:18:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:41163 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552Ab0CGBSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 20:18:36 -0500
Message-ID: <4B92FE9E.90600@kernel.org>
Date: Sat, 06 Mar 2010 17:17:18 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Johannes Weiner <hannes@cmpxchg.org>, Greg Thelen <gthelen@google.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, cl@linux-foundation.com
Subject: Re: mmotm boot panic bootmem-avoid-dma32-zone-by-default.patch
References: <49b004811003041321g2567bac8yb73235be32a27e7c@mail.gmail.com> <20100305032106.GA12065@cmpxchg.org> <4B90C921.6060908@kernel.org> <4B90DC3C.1060000@gmail.com>
In-Reply-To: <4B90DC3C.1060000@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2010 02:26 AM, Jiri Slaby wrote:
> On 03/05/2010 10:04 AM, Yinghai Lu wrote:
>> according to context
>> http://patchwork.kernel.org/patch/73893/
>>
>> Jiri, 
>> please check current linus tree still have problem about mem_map is using that much low mem?
> 
> Hi!
> 
> Sorry, I don't have direct access to the machine. I might try to ask the
> owners to do so.
> 
>> on my 1024g system first node has 128G ram, [2g, 4g) are mmio range.
> 
> So where gets your mem_map allocated (I suppose you're running flat model)?

what kernel version? 2.6.27?

x86 64bit now only support SPARSEMEM.

Yinghai

