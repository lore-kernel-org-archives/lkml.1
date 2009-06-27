Return-Path: <linux-kernel-owner+w=401wt.eu-S1756954AbZF0R1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954AbZF0R1U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 13:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756489AbZF0R1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 13:27:08 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:48501 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410AbZF0R1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 13:27:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=iwmVL2cVcV34CkkxcXzexSmLiYfuJmT5QkUKdGXyVoW/0OlPrFAIX3rx3bOsUAYTUN
         +u/uhodON3CE0mg/WUV3rSE0Gyn3zq9P5yTfFqU8JiWQe8acen45XpWfY1Jl12BWmNaA
         7AbG8YJQGJNRGRs/FyfXGQwJPDE6KW6R94ai0=
Message-ID: <4A46569E.2070501@gmail.com>
Date: Sat, 27 Jun 2009 11:27:58 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Zbigniew Luszpinski <zbiggy@o2.pl>
CC: linux-kernel@vger.kernel.org
Subject: Re: OHCI USB hangs during intensive use, nVidia MCP78S chipset, few
 questions to help me find the problem.
References: <200906271751.21418.zbiggy@o2.pl>
In-Reply-To: <200906271751.21418.zbiggy@o2.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2009 09:51 AM, Zbigniew Luszpinski wrote:
> Hello,
>
> after upgrading my CPU from single core to multicore and mainboard I started
> to have problem with OHCI USB controller. It hangs during big data transfer
> (USB hdd drive, pendrive, IRDA dongle or adsl modem). The result of hang is
> usb device is not responding. This is the only error I found. I would like to
> learn why it hangs and fix it. I tried kernels 2.6.27-30 and most popular
> Linux distributions. Adding noapic or acpi=noirq parameter to kernel boot line
> almost workarounds the problem, disabling tickless kernel: CONFIG_NO_HZ also
> makes usb ohci hanging a little bit less. Usb 1.1 devices still hangs but
> seldom: only transferring over 100MiB file to/from usb hdd or downloading
> CentOS dvd iso from ftp or torrent can hang usb. I do not want to be left with
> workaround. I want to fix it. Can you tell me how to find the issue and where
> to look for faulty code? By looking at kernel parameters which cures the usb
> ohci bug it must be something wrong with IRQs.

Are you getting any kernel errors/messages in dmesg? In any case you 
should post your dmesg output from bootup.
