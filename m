Return-Path: <linux-kernel-owner+w=401wt.eu-S1760888AbXERTvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760888AbXERTvw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 15:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754922AbXERTvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 15:51:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754357AbXERTvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 15:51:44 -0400
Message-ID: <464E03C5.6040507@redhat.com>
Date: Fri, 18 May 2007 15:51:33 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: eugene@ns.armcci.am
CC: linux-kernel@vger.kernel.org
Subject: Re: ht CPU flag
References: <Pine.LNX.4.64.0705182131030.25685@ns.armcci.am> <464DFBE0.5060904@redhat.com> <Pine.LNX.4.64.0705190023420.25685@ns.armcci.am>
In-Reply-To: <Pine.LNX.4.64.0705190023420.25685@ns.armcci.am>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

eugene@ns.armcci.am wrote:
> 
> 
> On Fri, 18 May 2007, Chris Snook wrote:
> 
>> eugene@ns.armcci.am wrote:
>>>  --------------------------------------------------------------------------- 
>>>
>>>
>>>  I have Pentium D CPU, which many Windows utilities like cpuz, wcpuid,
>>>  everest identify as D 930 (Dual Core, 3GHz). From Intel site I find out
>>>  that it has no HT feature, nor Windows XP identify it as HT.
>>>
>>>  Why do I have "ht" flag in cpuinfo?
>>>  -----------------------------------
>>
>> The "ht" flag merely means "I know how to report hyperthreaded logical 
>> processors if I have them."  My Woodcrest Xeon 5110 and my Athlon64 X2 
>> both have the "ht" flag, and correctly report the zero hyperthreaded 
>> logical processors they each have.
>>
>>     -- Chris
>>
>>
> 
> Thanks, Chris.
> 
> Am I right that is chipset on mainboard, who is saying - "I know....", 
> not CPU itself? Is it better to switch off HT support in BIOS?
> Is it possible to generate CPU name as: "Pentium D 930" in /proc/cpuinfo?
> On the other server I have some 2GHz HT Xeons which can't be identified 
> on Intel site because of strange naming pattern.
> I tried to find any utility for Linux to solve this, but it looks like 
> everybody are using /pros/cpuinfo, which is not enough :)
> 
> Regards, Eugene.

While the BIOS can disable HT, the ability to *report* HT or the lack thereof is 
within the CPU itself.  I doubt my socket AM2 board has the faintest clue what 
HT is.

As for human-readable names, the model name in /proc/cpuinfo comes from the 
processor name string, and includes however much or little information the 
vendor thinks the lay user wants to know.  If you want more detail, you can 
always interpret the model, stepping, and other related fields to determine the 
model number.

If you don't want to manually look up model info on a CPU version table, x86info 
and dmidecode will give you more information.

	-- Chris
