Return-Path: <linux-kernel-owner+w=401wt.eu-S932488AbZKXMp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488AbZKXMp1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 07:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932402AbZKXMp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 07:45:27 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:50680 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932329AbZKXMp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 07:45:26 -0500
Message-ID: <4B0BD562.4010602@petalogix.com>
Date: Tue, 24 Nov 2009 13:45:22 +0100
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: steve@digidescorp.com
CC: monstr@monstr.eu, microblaze-uclinux@itee.uq.edu.au,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RESEND] microblaze: Fix level interrupt ACKing
References: <1258469019-3863-1-git-send-email-steve@digidescorp.com>	 <4B067868.9070902@monstr.eu> <1258742956.2881.3.camel@iscandar.digidescorp.com>
In-Reply-To: <1258742956.2881.3.camel@iscandar.digidescorp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven J. Magnani wrote:
> On Fri, 2009-11-20 at 12:07 +0100, Michal Simek wrote:
>> Hi Steve,
>>
>> steve@digidescorp.com wrote:
>>> Level interrupts need to be ack'd in the unmask handler, as in powerpc. 
>>> Among other issues, this bug causes the system clock to appear to run at 
>>> double-speed.
>> Can you send me any step-by-step manual how to demonstrate me this 
>> fault? If system clock runs at double-speed, then I should be able able 
>> to see that time is two times faster. Or do you mean different behavior?
> 
> Unless there's a way to read jiffies_64 in userspace, the easiest way I
> know of is to use the debugger. Stop the kernel soon after you boot it,
> and read jiffies_64. Continue execution for some known amount of
> wall-clock time, then stop the kernel again and recheck jiffies_64.
> Without the patch, the number of elapsed jiffies is twice what you'd
> expect based on HZ.

yes, I saw that behavior. Just thinking what caused that jiffies was two 
times faster.

But anyway. I added this patch to next branch.

Thanks,
Michal

> 
>> Thanks,
>> Michal
> 
> Regards,
> ------------------------------------------------------------------------
>  Steven J. Magnani               "I claim this network for MARS!
>  www.digidescorp.com              Earthling, return my space modulator!"
> 
>  #include <standard.disclaimer>
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663
