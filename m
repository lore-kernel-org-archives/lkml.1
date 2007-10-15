Return-Path: <linux-kernel-owner+w=401wt.eu-S1763950AbXJOLLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763950AbXJOLLb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 07:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760560AbXJOLLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 07:11:23 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:43253 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759855AbXJOLLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 07:11:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=KlhkOpWWVhRt03OhrlplDg6fc4VZpBkOf58mT7K3kV8TooyvIXGM9j1sAGH1GoujKMZTZa2VD/8PPSD7C4T9VInj353ODJ4tjbjOptzL3Nh+uWC2L+2z/PI+7D5X/JO62QElR+4giqNVlRJ9l6VW5kjgQI3yWgAMjQiyjDld1zQ=
Message-ID: <47134ACF.8040608@gmail.com>
Date: Mon, 15 Oct 2007 15:11:11 +0400
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: John Sigler <linux.kernel@free.fr>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       robert.moore@intel.com, len.brown@intel.com
Subject: Re: halt does not shut the system down
References: <470A58AF.9080402@free.fr> <470C9731.6030200@free.fr> <470F4535.3050004@free.fr> <470F4F58.4080900@gmail.com> <470F7264.8070205@free.fr> <471342C8.2030305@free.fr>
In-Reply-To: <471342C8.2030305@free.fr>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Sigler wrote:
> John Sigler wrote:
> 
>> Alexey Starikovskiy wrote:
>>
>>> Could you please open bug at bugzilla.kernel.org and put all these
>>> files there?
>>
>> http://bugzilla.kernel.org/show_bug.cgi?id=9148
> 
> Writing 15361 (i.e. 0x3C01) to ACPI_REGISTER_PM1A_CONTROL appears to
> hang my system in acpi_os_write_port(). What can I do about that?
That is supposed to turn your machine off. At least we now know that ACPI 
did try to turn it off.
You could also try different kernel or defconfig.
> 
> Is it a BIOS issue? a kernel issue? a hardware issue?
I think _other_ OS could turn your machine off just fine, so the issue is not HW, not BIOS.
Probably, first thing to try is 2.6.23.1 as it was just released and has some changes in
power management section...

Regards,
Alex.
