Return-Path: <linux-kernel-owner+w=401wt.eu-S1758469AbYBYUsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758469AbYBYUsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 15:48:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750850AbYBYUsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 15:48:13 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:12203 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbYBYUsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 15:48:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=mGUguCYTzNZaeiYTkt7DFR/93YSudXYC7lJJnZC3FqTBFJsU3069D04Hkkp1WQv6ikNqCzIUCp7fgiZgdrCeDBLDa9a4Hf60pjJNkDKisvePC6rb8QYID6HWOJXgBgenYCy0sOvtyfF/z5wCoWu9AMdGVmdFVHovcBWwAtvQesk=
Message-ID: <47C32986.8010206@googlemail.com>
Date: Mon, 25 Feb 2008 21:48:06 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071204)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Robert Hancock <hancockr@shaw.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Gabriel C <crazy@frugalware.org>
Subject: Re: Clocksource tsc is always unstable with 2.6.25-* kernels and
 CONFIG_NO_HZ=y on my box
References: <fa.FpheN5sIQ5rxoLHYuhxxf6uauVs@ifi.uio.no> <47C24517.7010204@shaw.ca> <alpine.LFD.1.00.0802250839240.7583@apollo.tec.linutronix.de> <47C2F350.1060107@googlemail.com> <alpine.LFD.1.00.0802252031180.7583@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.00.0802252031180.7583@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Mon, 25 Feb 2008, Gabriel C wrote:
>>>>> Booting nohz=off fixes that.
>>>>>
>>>>> Another strange thing is when I try to boot that kernel with
>>>>> clocksource=acpi_pm it just hangs.
> 
> What happens if you add clocksource=acpi_pm and nohz=off to the kernel
> commandline ?
> 

Then the kernel boots and it seems to work.

http://frugalware.org/~crazy/dmesg/lara/dmesg2

>>>> Please post your full dmesg output.
>>> Yes please.
>> dmesg's from 2.6.25-rc3 witch nohz={on,off} , lspci , dmidecode and
>> the used config for this kernel can be found there :
>>
>> http://frugalware.org/~crazy/dmesg/lara/
> 
> Hmm. Nothing really obvious.

If you want I can build an debug kernel and boot with initcall_debug or anything else may help to find the problem,
just let me know.

> 
> Thanks,
> 	tglx
> 

Gabriel
