Return-Path: <linux-kernel-owner+w=401wt.eu-S1751137AbXBZGNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751137AbXBZGNr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 01:13:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbXBZGNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 01:13:47 -0500
Received: from mis011-1.exch011.intermedia.net ([64.78.21.128]:12588 "EHLO
	mis011-1.exch011.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751137AbXBZGNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 01:13:46 -0500
Message-ID: <45E27A94.3020400@qumranet.com>
Date: Mon, 26 Feb 2007 08:13:40 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Hollis Blanchard <hollis@penguinppc.org>
CC: kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [kvm-devel] PIO port width on various archs?
References: <45E14F9D.3050502@qumranet.com> <1172464067.12245.4.camel@diesel>
In-Reply-To: <1172464067.12245.4.camel@diesel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Feb 2007 06:13:45.0194 (UTC) FILETIME=[45470CA0:01C7596D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hollis Blanchard wrote:
> On Sun, 2007-02-25 at 10:58 +0200, Avi Kivity wrote:
>   
>> I'm changing the kvm userspace interface to be more friendly to other 
>> archs.  One issue is the PIO port size.  x86 uses 16 bits to hold the 
>> port size (64K ports).  Is that an issue for other archs?
>>
>> I guess I could change it to __u32, but it's better to know what various 
>> architectures actually require.
>>     
>
> PowerPC doesn't have any such concept; access to ISA PIO is done by
> having the bridge translate a particular range of MMIO accesses as PIO.
> I'm no expert, but I don't know of any mainstream processor other than
> x86 that supports PIO.
>
>   

I think ia64 does, but it's probably exactly the same as x86.


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

