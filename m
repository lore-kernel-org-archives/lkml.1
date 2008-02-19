Return-Path: <linux-kernel-owner+w=401wt.eu-S1758424AbYBSSdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424AbYBSSdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 13:33:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753989AbYBSSdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 13:33:24 -0500
Received: from mx.fenrir.org.uk ([81.168.115.223]:52926 "EHLO mx.fenrir.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549AbYBSSdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 13:33:23 -0500
Message-ID: <47BB20F0.8030506@fenrir.org.uk>
Date: Tue, 19 Feb 2008 18:33:20 +0000
From: Brian Morrison <bdm@fenrir.org.uk>
Organization: The Fool and Bladder Face-Jumping Team
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.8.1.9) Gecko/20071031 Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Intel Core2Duo mobile - how does the VID get set?
References: <47BAC961.6030808@fenrir.org.uk> <924EFEDD5F540B4284297C4DC59F3DEE90C8BD@orsmsx423.amr.corp.intel.com>
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEE90C8BD@orsmsx423.amr.corp.intel.com>
X-Enigmail-Version: 0.95.6
OpenPGP: id=E79E0778
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEU8PDpvaFEREREpKiXC
 wsD//////v6hSyaYAAABLElEQVQ4jZ3TwW7DIAwAUFOqnbFCf4DtA5K62jloTu+VWs6rFPL/nzAg
 WUY7qNb5EqInY8dW4FIJ+C84X4GRR+apCGgRNR/vge0WERvN/g5QiQhSiCGDkSclAQAboajzObCS
 JgRtOqLhmgqB44nZzmDMK5H+OCzAETY0iyHs33y6amLNFjaGliTQVh9TDRf6Adgb00I0AIU4JLCo
 IEmo0Yb2Quc6AXPIAJD7+arYOM7tohUxJwZReszgJhYINyGWkZzXjDtwqTyI8EnLaV2UjXfpdBzZ
 4u5ntbGz7fdLWOgKrpd0+L3BECei7jk4E7VlkES+BC7A8BRcmgewK0L/AF5q8F6ET8qHlcGpCjIf
 VgbnB9BWwZfgdlj57ww1UPlM/gR97SqLXOzqNqrwBbAjNHgb3BUMAAAAAElFTkSuQmCC
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pallipadi, Venkatesh wrote:

>> After a fair bit of Googling and reading around, I'm none the wiser 
>> about exactly how Linux 2.6.x sets the processor VID (or for 
>> that matter 
>> how it decides the FID settings) when using the ondemand governor and 
>> cpufreq stuff.
>>
>> Can anyone tell me a) whether this is obtained from the BIOS, 
>> something 
>> in the MSR of the processor or elsewhere and
> 
> Yes. The freq and voltage supported comes from the platform BIOS. BIOS
> exports this in an ACPI table which is handled by acpi-cpufreq driver in
> Linux kernel.
> 

OK, thanks for that.

>  
>> b) whether there is an 
>> interface in /proc or /sys where one can find out what is set 
>> and modify it?
> 
> There is no way of modifying and using new VIDs etc in Linux kernel
> (other than exporting your own DSDT and hacking the related code).

Is there a way of viewing the ACPI table contents relating to the VIDs
and FIDs?

-- 

Brian Morrison

bdm@fenrir.org.uk

