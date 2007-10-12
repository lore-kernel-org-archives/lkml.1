Return-Path: <linux-kernel-owner+w=401wt.eu-S1760078AbXJLKlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760078AbXJLKlp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 06:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbXJLKlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 06:41:36 -0400
Received: from hu-out-0506.google.com ([72.14.214.227]:37641 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbXJLKlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 06:41:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=twYH/up6R2+0J2Yo4R3Hi/Eyc6e83THoSR7ucvjjnYLFDTUry6mhcMg8w3OYMQHzu7qcaQHVwq6B/FJKTb5KYn4ZifUBpfROyD/YxLnSw/wHLILwG9NM8o/JTcplr6qxh056YJv86UzljCp8GXGXUkRVvIM+gAJIghwMt85byqQ=
Message-ID: <470F4F58.4080900@gmail.com>
Date: Fri, 12 Oct 2007 14:41:28 +0400
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: John Sigler <linux.kernel@free.fr>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       robert.moore@intel.com, len.brown@intel.com
Subject: Re: halt does not shut the system down
References: <470A58AF.9080402@free.fr> <470C9731.6030200@free.fr> <470F4535.3050004@free.fr>
In-Reply-To: <470F4535.3050004@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Could you please open bug at bugzilla.kernel.org and put all these files there?

Thanks,
Alex.

John Sigler wrote:
> John Sigler wrote:
> 
>> When I run 'halt' the kernel prints:
>>
>> Halting.
>> Shutdown: hdc
>> ACPI: PCI interrupt for device 0000:01:05.0 disabled
>> ACPI: PCI interrupt for device 0000:01:04.0 disabled
>> ACPI: PCI interrupt for device 0000:01:03.0 disabled
>> ACPI: PCI interrupt for device 0000:01:02.0 disabled
>> Power down.
>> acpi_power_off called
>>
>> But the system does not shut down. (The fans keep spinning, the LEDs 
>> keep shining, the LCD keeps displaying.) Basically, the motherboard is 
>> still providing power to every component, as if the power supply had 
>> refused to stop.
>>
>> http://linux.kernel.free.fr/halt/config-2.6.22.1-rt9
>> http://linux.kernel.free.fr/halt/acpidump.txt
>> http://linux.kernel.free.fr/halt/dmesg.txt
>> http://linux.kernel.free.fr/halt/halt.txt
>> http://linux.kernel.free.fr/halt/lspci.txt
> 
> Is there something else I can provide that might help in identifying
> the problem?
> 
> Regards.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

