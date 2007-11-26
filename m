Return-Path: <linux-kernel-owner+w=401wt.eu-S1757562AbXKZDOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562AbXKZDOY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 22:14:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754404AbXKZDOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 22:14:15 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:53779 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354AbXKZDOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 22:14:15 -0500
Message-ID: <474A369C.4000101@student.ltu.se>
Date: Mon, 26 Nov 2007 03:59:40 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Samuel Ortiz <samuel@sortiz.org>
CC: davem@davemloft.net, linux-kernel@vger.kernel.org,
       irda-users@lists.sourceforge.net
Subject: Re: [PATCH] net/irda/parameters.c: Trivial fixes
References: <20071124203232.6370.65534.sendpatchset@thinktank.campus.ltu.se> <20071126091747.GB3165@sortiz.org>
In-Reply-To: <20071126091747.GB3165@sortiz.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel Ortiz wrote:
> Hi Richard,
>
> On Sat, Nov 24, 2007 at 09:44:05PM +0100, Richard Knutsson wrote:
>   
>> Make a single va_start() -> va_end() path + fixing:
>>     
> Ok, this should be 2 separate patches then.
>   
Thought about it, but they were so simple, I believed they would better 
be merged...
> The warning fixes are all good, but I fail to see the point of the va_end()
> one. That doesn't seem to bring any sort of improvement while adding one
> variable to the stack and one loop test. Any explanation here ?
>   
Not really. Many seem to like a single return and since this made it one 
va_end() to every va_start(), I thought it would be appropriate. But if 
not, then I will only filter this hit out from the 
va_start()->va_end()-testing and get going.
> I'll push the warning fix for now, thanks.
>   
Alright, thank you.
> Cheers,
> Samuel.
>
>   
cu
Richard Knutsson

