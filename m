Return-Path: <linux-kernel-owner+w=401wt.eu-S1756609AbYHMRi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609AbYHMRi2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 13:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbYHMRiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 13:38:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56771 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbYHMRiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 13:38:19 -0400
Message-ID: <48A31BF5.7060608@zytor.com>
Date: Wed, 13 Aug 2008 10:37:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mark Langsdorf <mark.langsdorf@amd.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: invalidate caches before going into suspend
References: <200808131141.18003.mark.langsdorf@amd.com> <20080813164728.GD5720@elte.hu> <48A31188.4050904@zytor.com> <20080813170133.GA16557@elte.hu> <48A319AB.9030707@zytor.com> <20080813173507.GA30911@elte.hu>
In-Reply-To: <20080813173507.GA30911@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>>>
>> Not significantly, but I cannot for my life figure out how it could 
>> help.
>>
>> Either the interrupts will be blocked by the CLI already in effect, or 
>> the additional CLI will not help, either (in fact, it will just 
>> slightly increase the window for something like that to slip in.)
> 
> ah, the main point i tried to make was to have the CLI _before_ the 
> WBINVD - which Mark's patch didnt do.
> 

Ah yes, that's important.

	-hpa
