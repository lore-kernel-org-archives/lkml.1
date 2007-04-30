Return-Path: <linux-kernel-owner+w=401wt.eu-S1752929AbXD3WSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbXD3WSc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 18:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753306AbXD3WSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 18:18:32 -0400
Received: from rutherford.zen.co.uk ([212.23.3.142]:41110 "EHLO
	rutherford.zen.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbXD3WSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 18:18:31 -0400
Message-ID: <46366B34.3050003@gmail.com>
Date: Mon, 30 Apr 2007 23:18:28 +0100
From: Matt Keenan <tank.en.mate@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: William Lee Irwin III <wli@holomorphy.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Bradley Chapman <kakadu@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: CONFIG_HIGHMEM4G and 1GB RAM
References: <e294b46e0704281326w60f9cecfuace3442791f147b3@mail.gmail.com> <20070430001755.e9f203c9.akpm@linux-foundation.org> <20070430074044.GB19966@holomorphy.com>
In-Reply-To: <20070430074044.GB19966@holomorphy.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-Rutherford-IP: [82.69.27.224]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
> On Sat, 28 Apr 2007 21:26:42 +0100 "Bradley Chapman" <kakadu@gmail.com> wrote:
>   
>>> Basically, all I want to know is whether or not enabling
>>> CONFIG_HIGHMEM4G for a laptop that has exactly 1GB of RAM will result
>>> in any performance degradation.
>>>       
>
> On Mon, Apr 30, 2007 at 12:17:55AM -0700, Andrew Morton wrote:
>   
>> I would expect the advantages of the additional 128MB to considerably
>> outweigh the cost of turning on CONFIG_HIGHMEM4G.
>> That cost will be a little extra CPU consumption inside the kernel, but the
>> great majority of CPU consumption usually happens in userspace anyway.
>>     
>
> The CONFIG_VMSPLIT config options were merged for such cases.
>
> It should be able to split on any 4MB-aligned boundary in
> CONFIG_HIGHMEM4G. CONFIG_VMSPLIT_3G_OPT appears to do something of
> this sort to use an entire 1GB RAM with minimal user address space
> reduction.
>
> This is an ELF ABI violation but the number of major applications
> that break is apparently low.
>
>   
wine and some java implementations being two of the big caveats.

Matt

