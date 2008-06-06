Return-Path: <linux-kernel-owner+w=401wt.eu-S1764121AbYFFIAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764121AbYFFIAS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 04:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753794AbYFFIAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 04:00:07 -0400
Received: from gw.goop.org ([64.81.55.164]:57583 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752928AbYFFIAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 04:00:05 -0400
Message-ID: <4848EE5C.6040003@goop.org>
Date: Fri, 06 Jun 2008 08:59:24 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Beulich <jbeulich@novell.com>, Stable Kernel <stable@kernel.org>
Subject: Re: [PATCH] x86: set PAE PHYSICAL_MASK_SHIFT to match 64-bit
References: <4848046A.5060006@goop.org> <87ve0ntk6v.fsf@basil.nowhere.org>
In-Reply-To: <87ve0ntk6v.fsf@basil.nowhere.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Jeremy Fitzhardinge <jeremy@goop.org> writes:
>   
>> The 46-bit mask used in 64-bit seems pretty arbitrary. 
>>     
>
> The rationale for the 46 bits is that the kernel needs roughly 4x as 
> much virtual space as physical space and the virtual space is limited
> to 48bits.
>
> To be exact 47 bits is always user space and the 47 bits remaining
> for the kernel are split into half, with one half for the direct mapping
> and the other half for random mappings.  With some pushing you could
> extend it to 46.5 bits or so, but beyond that you'll be in trouble.
>   

Why's that?  Is the issue the amount of memory needed for pagetables and 
page structures if you did have more than 2^48 bytes of physical memory?

> It's not arbitrary at all.
I didn't say it was.  That was the introduction to my explanation of why 
I didn't think it was arbitrary.  Of course, if there had been a comment 
there explaining the rationale, I wouldn't have had to make one up...

    J
