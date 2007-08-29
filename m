Return-Path: <linux-kernel-owner+w=401wt.eu-S1760238AbXH2Tp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760238AbXH2Tp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 15:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754962AbXH2TpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 15:45:22 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:44035 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754819AbXH2TpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 15:45:21 -0400
Message-ID: <46D5CCBD.5050103@suse.de>
Date: Wed, 29 Aug 2007 23:45:01 +0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Daniel Ritz <daniel.ritz-ml@swissonline.ch>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: Linux 2.6.23-rc4: BAD regression
References: <200708290129.57243.daniel.ritz-ml@swissonline.ch> <46D4F905.6080908@suse.de> <200708292135.57584.daniel.ritz-ml@swissonline.ch>
In-Reply-To: <200708292135.57584.daniel.ritz-ml@swissonline.ch>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If you could open a bugreport at bugzilla.kernel.org in ACPI category
and attach
dmesg and acpidump output, that would help a lot. (I hope :( )

Thanks,
Alex.

Daniel Ritz wrote:
> On Wednesday 29 August 2007 06:41:41 Alexey Starikovskiy wrote:
>   
>> Daniel,
>> Does this patch help you, or do we need to revert the whole thing?
>>
>>     
>
> yes, this does the trick. the fan goes on again. thanks.
> if you still need additional debug output or if you want me to test
> a different patch just let me know.
>
> rgds
> -daniel
>
>   
>> Sorry for the trouble,
>> Alex.
>> Daniel Ritz wrote:
>>     
>>> tried that one on my old toshiba tecra 8000 laptop, almost killing it.
>>> the fan doesn't work any more...type 'make' and see the box dying.
>>> luckily my CPU doesn't commit suicide...bisected it to that one:
>>>
>>> cd8c93a4e04dce8f00d1ef3a476aac8bd65ae40b is first bad commit
>>> commit cd8c93a4e04dce8f00d1ef3a476aac8bd65ae40b
>>> Author: Alexey Starikovskiy <astarikovskiy@suse.de>
>>> Date:   Fri Aug 3 17:52:48 2007 -0400
>>>
>>>     ACPI: EC: If ECDT is not found, look up EC in DSDT.
>>>
>>>     Some ASUS laptops access EC space from device _INI methods, but do not
>>>     provide ECDT for early EC setup. In order to make them function properly,
>>>     there is a need to find EC is DSDT before any _INI is called.
>>>
>>>     Similar functionality was turned on by acpi_fake_ecdt=1 command line
>>>     before. Now it is on all the time.
>>>
>>>     http://bugzilla.kernel.org/show_bug.cgi?id=8598
>>>
>>>     Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
>>>     Signed-off-by: Len Brown <len.brown@intel.com>
>>>   
>>>       
>
>
>   

