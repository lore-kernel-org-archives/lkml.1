Return-Path: <linux-kernel-owner+w=401wt.eu-S1764933AbXJON3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764933AbXJON3a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 09:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757815AbXJON3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 09:29:22 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:40542 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757109AbXJON3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 09:29:21 -0400
Message-ID: <47136B2F.9070904@free.fr>
Date: Mon, 15 Oct 2007 15:29:19 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Alexey Starikovskiy <aystarik@gmail.com>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       robert.moore@intel.com, len.brown@intel.com
Subject: Re: halt does not shut the system down
References: <470A58AF.9080402@free.fr> <470C9731.6030200@free.fr> <470F4535.3050004@free.fr> <470F4F58.4080900@gmail.com> <470F7264.8070205@free.fr> <471342C8.2030305@free.fr> <47134ACF.8040608@gmail.com>
In-Reply-To: <47134ACF.8040608@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Starikovskiy wrote:

> John Sigler wrote:
> 
>> Alexey Starikovskiy wrote:
>> 
>>> Could you please open bug at bugzilla.kernel.org and put all
>>> these files there?
>> 
>> http://bugzilla.kernel.org/show_bug.cgi?id=9148
>> 
>> Writing 15361 (i.e. 0x3C01) to ACPI_REGISTER_PM1A_CONTROL appears
>> to hang my system in acpi_os_write_port(). What can I do about that?
> 
> That is supposed to turn your machine off. At least we now know that
> ACPI did try to turn it off. You could also try different kernel or
> defconfig.

What's defconfig? .config? Which option(s) might have an impact?

>> Is it a BIOS issue? a kernel issue? a hardware issue?
> 
> I think _other_ OS could turn your machine off just fine, so the
> issue is not HW, not BIOS. Probably, first thing to try is 2.6.23.1
> as it was just released and has some changes in power management
> section...

I have the same problem in 2.6.23.1 (cf. my bug report in the database)

I'll ask the manufacturer whether they could get poweroff to work.

Regards.
