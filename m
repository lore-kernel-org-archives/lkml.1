Return-Path: <linux-kernel-owner+w=401wt.eu-S1764962AbYEAV1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764962AbYEAV1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 17:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932388AbYEAV07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 17:26:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51600 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932334AbYEAV06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 17:26:58 -0400
Message-ID: <481A356C.5090502@zytor.com>
Date: Thu, 01 May 2008 14:26:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Gabriel C <nix.or.die@googlemail.com>,
       Mika Fischer <mika.fischer@zoopnet.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: mtrr cleanup for converting continuous to discrete
 - auto detect v2
References: <200804272337.40130.yhlu.kernel@gmail.com>	 <200804292025.58268.yhlu.kernel@gmail.com>	 <200805010100.34751.yhlu.kernel@gmail.com>	 <200805011157.00693.yhlu.kernel@gmail.com>	 <481A1D3A.5040202@zytor.com>	 <86802c440805011402h1e452b57ma27ffa6ad7b50238@mail.gmail.com>	 <481A31E2.2020800@zytor.com> <86802c440805011420g78a6abberaae6b765663ed33b@mail.gmail.com>
In-Reply-To: <86802c440805011420g78a6abberaae6b765663ed33b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
>>>
>>  Yes, 16 GB systems are already mainstream; 32 GB is common, so I don't see
>> any reason to stop at 2 GB.  Instead, it should loop up to the physical
>> address size.
> 
> but our objective is that has 0xd0000000-0xe0000000 (WC) not to be
> overlapping with other MTRR entries (UC)..
> 

So, pray tell, how comes this algorithm can come up with a non-solution 
to the problem presented to it?

Overall, I'm feeling there is something really completely wrong if this 
needs manual tunables of any sort.

	-hpa
