Return-Path: <linux-kernel-owner+w=401wt.eu-S1757396AbXGBLWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396AbXGBLWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 07:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbXGBLWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 07:22:23 -0400
Received: from messidor.freesurf.fr ([212.43.206.29]:49083 "EHLO
	smtp-out.freesurf.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752880AbXGBLWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 07:22:22 -0400
Message-ID: <38318.82.227.54.211.1183375340.squirrel@arlette.freesurf.fr>
Date: Mon, 2 Jul 2007 13:22:20 +0200 (CEST)
Subject: Re: 2.6.21-rt9 problem : xruns
From: <skyball000@freesurf.fr>
To: <g.liakhovetski@gmx.de>
X-Priority: 3
In-Reply-To: <Pine.LNX.4.60.0706292225400.4227@poirot.grange>
References: <Pine.LNX.4.60.0706292225400.4227@poirot.grange>
Importance: Normal
X-MSMail-Priority: Normal
Cc: <linux-kernel@vger.kernel.org>
X-Mailer: SquirrelMail (version 1.2.5)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 29 Jun 2007 skyball000@freesurf.fr wrote:
>
>> Hi,
>>
>> I've recently compiled a "vanilla" 2.6.21 kernel, patched with Ingo
>> Molnar's rt-8 patch, as I was unable to compile with rt-7.
>>
>> I needed it because I'm using audio applications (tests were made with
>> FrugalWare, but I don't think it's a distro issue).
>>
>> Everything was allright until I changed my motherboard for an  Asrock
>> 4coreDual-Vsta (I formerly used a Nforce4 one), with VIA PT880 Ultra
>> chipset.
>>
>> I've justed switched the hardware, as Linux is neat enough to boot
>> without having to reinstall the whole OS.
>>
>> Since, I get tons of xruns when using RT applications, and the only
>> solution I've found to "fix" it was to disable ACPI at boot time.
>
> Interestingly, this looks very similar to a problem I had... Could you,
>  please, verify if acpid is running (with ACPI configured on), and if
> yes -  stop it and retest for xruns?
>
> Thanks
> Guennadi
>
I've only seen a "kacpid" (unkillable), managed to stop ACPI services with
init scripts but xruns are still there (a few less).

>> Moreover, I get this message at boot time :
>> PCI: BIOS bug: MCFG area@e0000000 is not E820 reserved
>> PCI: not using MMCONFIG
>>
>> I've also tested this hardware setup with a UbuntoStudio kernel
>> (2.6.19), and everything works flawlessy (no XRUNS, no kernel
>> messages) !
>>
>> So here is my question (I'd like to understand what's happening) :
>>    - is it a kernel (or patch) issue ?
>>    - is it a bad chipset support in the latest kernel versions ? -
>>    could this be related to BIOS issues only (I've tried all available
>> versions without any change) ?
>>    - should I use special settings in the ".config" in order to avoid
>>    these
>> problems ?
>>
>> I wasn't able to detect what causes these XRUNS, so if anyone has
>> clues ...
>>
>> Regards
>> skb
>>
>>
>>
>>
>>
>> -
>> To unsubscribe from this list: send the line "unsubscribe
>> linux-kernel" in the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
> ---
> Guennadi Liakhovetski



