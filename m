Return-Path: <linux-kernel-owner+w=401wt.eu-S1764020AbYFGSnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764020AbYFGSnI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 14:43:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760479AbYFGSm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 14:42:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33730 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317AbYFGSm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 14:42:56 -0400
Message-ID: <484AD5DD.9040403@kernel.org>
Date: Sat, 07 Jun 2008 11:39:25 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, Stable Kernel <stable@kernel.org>,
       x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: set PAE PHYSICAL_MASK_SHIFT to match 64-bit
References: <4848046A.5060006@goop.org> <87ve0ntk6v.fsf@basil.nowhere.org> <4848EE5C.6040003@goop.org> <48490DEC.76E4.0078.0@novell.com> <4848F233.10008@goop.org>
In-Reply-To: <4848F233.10008@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
>>
>> No, it's the fact that the 1:1 mapping needs as much virtual space as
>> the physical range covered (including all holes).
> 
> Right, I see.  And suddenly 64-bits seems... constrained. ;)
> 

Not really.  The vendors are aware of this constraint -- it's hardly 
unique to Linux.  The reason for canonical addresses and all that jazz 
is to keep people from doing stupid things like store stuff in the upper 
16 bits of a pointer (happened a lot on the 68000, where the first 
implementation had only 24 address bits.)  Thus, all changes needed to 
go to a larger virtual address space are all internal to the kernel.

	-hpa
