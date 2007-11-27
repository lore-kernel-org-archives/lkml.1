Return-Path: <linux-kernel-owner+w=401wt.eu-S1754163AbXK0HwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbXK0HwU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 02:52:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750859AbXK0HwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 02:52:11 -0500
Received: from gate.crashing.org ([63.228.1.57]:40956 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbXK0HwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 02:52:10 -0500
Cc: Daniel Drake <dsd@gentoo.org>, linux-kernel@vger.kernel.org,
       davem@davemloft.net, kune@deine-taler.de, johannes@sipsolutions.net
Message-Id: <D55ECED4-D826-4F65-AAE0-87C0798024B0@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Heikki Orsila <shdl@zakalwe.fi>
In-Reply-To: <20071123114329.GG7681@zakalwe.fi>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Subject: Re: [RFC] Documentation about unaligned memory access
Date: Tue, 27 Nov 2007 01:51:38 -0600
References: <20071123001554.12F8B9D4A1F@zog.reactivated.net> <20071123114329.GG7681@zakalwe.fi>
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 23, 2007, at 5:43 AM, Heikki Orsila wrote:

> On Fri, Nov 23, 2007 at 12:15:53AM +0000, Daniel Drake wrote:
>> Why unaligned access is bad
>> ===========================
>>
>> Most architectures are unable to perform unaligned memory accesses.  
>> Any
>> unaligned access causes a processor exception.
>
> "Some architectures are unable to perform unaligned memory accesses,
> either an exception is generated, or the data
> access is silently invalid. In architectures that allow unaligned
> access, natural aligned accesses are usually faster than non-aligned."
>
>> In summary: if your code causes unaligned memory accesses to  
>> happen, your code
>> will not work on some platforms, and will perform *very* badly on  
>> others.
>
> *very* -> *slower*
>
>> Natural alignment
>> =================
>
> Please move this definition before "Why unaligned access is bad".
>
> Also, it would be nice to have a table of ISAs:
>
> ISA		Need		Need
> 		natural		alignment
> 		alignment	by x
> --------------------------------------------
> m68k		No		2
> powerpc/ppc	Yes		Word size

on ppc it varies from processor to processor if misaligned data is  
fixed up or causes an exception.  However its highly recommend to be  
naturally aligned.  I'm not sure I follow what is meant by the second  
column (need alignment by x).

- k
