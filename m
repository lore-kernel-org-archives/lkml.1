Return-Path: <linux-kernel-owner+w=401wt.eu-S1756690AbYFJNH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbYFJNH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 09:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753257AbYFJNHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 09:07:21 -0400
Received: from gw.goop.org ([64.81.55.164]:33761 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752767AbYFJNHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 09:07:21 -0400
Message-ID: <484E7C5D.50701@goop.org>
Date: Tue, 10 Jun 2008 14:06:37 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jan Beulich <jbeulich@novell.com>, Stable Kernel <stable@kernel.org>,
       x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH UPDATED] x86: set PAE PHYSICAL_MASK_SHIFT to 44 bits.
References: <4848046A.5060006@goop.org> <484823BD.76E4.0078.0@novell.com> <484901A3.3040401@goop.org> <20080610103151.GG19136@elte.hu>
In-Reply-To: <20080610103151.GG19136@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> When a 64-bit x86 processor runs in 32-bit PAE mode, a pte can 
>> potentially have the same number of physical address bits as the 
>> 64-bit host ("Enhanced Legacy PAE Paging").  This means, in theory, we 
>> could have up to 52 bits of physical address in a pte.
>>
>> The 32-bit kernel uses a 32-bit unsigned long to represent a pfn. This 
>> means that it can only represent physical addresses up to 32+12=44 
>> bits wide.  Rather than widening pfns everywhere, just set 2^44 as the 
>> Linux x86_32-PAE architectural limit for physical address size.
>>     
>
> applied to tip/x86/cleanups - thanks Jeremy. No urgency for v2.6.26, 
> right?

Not urgent, but it would be nice to have.

    J

