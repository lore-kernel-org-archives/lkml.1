Return-Path: <linux-kernel-owner+w=401wt.eu-S1756240Ab0A0WOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab0A0WOm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 17:14:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756199Ab0A0WOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 17:14:40 -0500
Received: from smtp-out2.blueyonder.co.uk ([195.188.213.5]:34474 "EHLO
	smtp-out2.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756197Ab0A0WOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 17:14:38 -0500
Message-ID: <4B60BAC9.3080002@blueyonder.co.uk>
Date: Wed, 27 Jan 2010 22:14:33 +0000
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.14 Thunderbird/3.0 ThunderBrowse/3.2.7
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: HDA Intel Audio hang on boot
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera>	<201001261922.35213.rjw@sisk.pl>	<4B5F5777.8070701@blueyonder.co.uk>	<201001270156.46217.rjw@sisk.pl>	<4B5FA785.3010002@blueyonder.co.uk>	<s5hljfk82wn.wl%tiwai@suse.de>	<4B607510.6020204@blueyonder.co.uk> <s5hhbq7l520.wl%tiwai@suse.de>
In-Reply-To: <s5hhbq7l520.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/01/10 19:29, Takashi Iwai wrote:
> At Wed, 27 Jan 2010 17:17:04 +0000,
> Sid Boyce wrote:
>>
>> On 27/01/10 06:42, Takashi Iwai wrote:
>>> At Wed, 27 Jan 2010 02:40:05 +0000,
>>> Sid Boyce wrote:
>>>>
>>>> On 27/01/10 00:56, Rafael J. Wysocki wrote:
>>>>> On Tuesday 26 January 2010, Sid Boyce wrote:
>>>>>> I forgot to mention 2.6.33-rc5 now boots successfully.
>>>>>
>>>>> Does that mean the problem is fixed in 2.6.33-rc5 or you still need the
>>>>> enable_msi=0 workaround?
>>>>>
>>>>> Rafael
>>>>>
>>>> It boots only with the enable_msi=0 workaround.
>>>
>>> OK, then could you run alsa-info.sh (with --no-upload option), and
>>> attach the generated file?  I'll add your device to the blacklist for
>>> disabling MSI in hda_intel.c.
>>>
>>>
>>> thanks,
>>>
>>> Takashi
>>>
>>>
>>
>> Thanks.
> 
> OK, I added the corresponding quirk entry to sound git tree.
> The patch will be included in the next pull request so that it'll
> be fixed in 2.6.33-rc6.
> 
> 
> thanks,
> 
> Takashi
> 

Thanks, I shall give a try then.
Regards
Sid.

-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

