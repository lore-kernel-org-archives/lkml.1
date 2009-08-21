Return-Path: <linux-kernel-owner+w=401wt.eu-S1755756AbZHUSUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756AbZHUSUT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 14:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755594AbZHUSUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 14:20:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37503 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbZHUSUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 14:20:17 -0400
Message-ID: <4A8EE544.6020002@zytor.com>
Date: Fri, 21 Aug 2009 11:19:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Tobias Doerffel <tobias.doerffel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Kelly Bowa <kelly.bowa@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: Atom processor inclusion
References: <20090820130648.6e7236f7@titus> <20090820105029.GF29093@elte.hu> <200908201433.54785.tobias.doerffel@gmail.com>
In-Reply-To: <200908201433.54785.tobias.doerffel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2009 05:33 AM, Tobias Doerffel wrote:
> Hi,
> 
> Am Donnerstag, 20. August 2009 12:50:29 schrieb Ingo Molnar:
>> Yep, it looked acceptable - Tobias, do you have any
>> updates / latest version of that patch?
> No - it's still the improved version I posted at the end of May [1]. The 
> question is what to do with MODULE_PROC_FAMILY (CORE2 or ATOM) and the mtune-
> fallback (generic, i686, ...)?
> 

Without benchmarks, we're flying blind on that one... although in
general, "generic" is probably best in the sense that it doesn't imply
that anything else has been done to it.

As far as MODULE_PROC_FAMILY it really comes down to if we use movbe or
not, which I don't believe your patch does.  On the other hand, I really
think it's extremely unlikely that anyone will use modules compiled for
a different CPU, so I'm personally fine with changing that string.

That whole mechanism is kind of broken, anyway.

	-hpa
