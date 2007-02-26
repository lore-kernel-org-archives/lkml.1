Return-Path: <linux-kernel-owner+w=401wt.eu-S1030461AbXBZTTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030461AbXBZTTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 14:19:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030474AbXBZTTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 14:19:09 -0500
Received: from terminus.zytor.com ([192.83.249.54]:36419 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030461AbXBZTTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 14:19:08 -0500
Message-ID: <45E332A1.6080504@zytor.com>
Date: Mon, 26 Feb 2007 11:18:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       trivial@kernel.org
Subject: Re: [PATCH] Remove redundant #ifdef __KERNEL__ checks.
References: <Pine.LNX.4.64.0702251509440.27758@CPE00045a9c397f-CM001225dbafb6> <45E2926C.40009@zytor.com> <Pine.LNX.4.64.0702260442160.15535@CPE00045a9c397f-CM001225dbafb6>
In-Reply-To: <Pine.LNX.4.64.0702260442160.15535@CPE00045a9c397f-CM001225dbafb6>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
> On Sun, 25 Feb 2007, H. Peter Anvin wrote:
> 
>> Robert P. J. Day wrote:
>>>   Remove the redundant intermediate checks for __KERNEL__ since, as
>>> soon as one ends, the next one starts.
>>>
>>> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
>>>
>> However, what's much worse is that this already has put series of
>> constants which are part of the ABI under __KERNEL__.  This is a
>> very bad thing.
> 
> i'm sure i'm just being dense but i have no clue what you're referring
> to.  AFAICT, that patch simply removed some redundant preprocessor
> directives.  am i missing something?
> 

I'm referring to the the patch that caused the redundant ifdefs, which 
was a recent change which among other things broke klibc.

	-hpa
