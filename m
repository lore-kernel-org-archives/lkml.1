Return-Path: <linux-kernel-owner+w=401wt.eu-S1030608AbXCFXCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030608AbXCFXCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 18:02:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030616AbXCFXCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 18:02:17 -0500
Received: from mail.tmr.com ([64.65.253.246]:59128 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030608AbXCFXCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 18:02:17 -0500
Message-ID: <45EDF33C.1060806@tmr.com>
Date: Tue, 06 Mar 2007 18:03:24 -0500
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.22 patch] the scheduled removal of OBSOLETE_OSS options
References: <20070305014956.GE3441@stusta.de> <45EDA8EE.1060308@tmr.com> <20070306175504.GW3441@stusta.de>
In-Reply-To: <20070306175504.GW3441@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Tue, Mar 06, 2007 at 12:46:22PM -0500, Bill Davidsen wrote:
>   
>> Adrian Bunk wrote:
>>     
>>> This patch contains the scheduled removal of the OBSOLETE_OSS options 
>>> for 2.6.22.
>>>
>>>       
>> If these are drivers for which there are thought to be useful ALSA 
>> drivers, would it be reasonable to leave a stub for a help file naming 
>> the driver which claims to support the hardware?
>>
>> I'm not objection to the removal of the drivers, just noting that 
>> identifying the new drivers can be made easier.
>>     
>
> People compiling their own kernels aren't completely dumb - if you know 
> about people having problems finding the right ALSA driver for their 
> hardware, please name the concrete problems so that we can improve the 
> description and/or help text of these ALSA options.
>   
I'm not sure how my original note might have been clearer, but let me 
try again.

You are about to delete a number of OSS drivers because there are ALSA 
drivers for the hardware. I am assuming that for each of there drivers 
you have some ALSA driver in mind, rather than just just general 
handwaving. I therefore suggest that it would be good if one person, 
that would be you, could do a little Kconfig magic so that when 'make 
oldconfig' on new kernel source fails to support sound, there might be a 
message in the output with a hint, like 'OSS driver XXXX has been 
deleted and ALSA driver YYYY should support this hardware.' So one 
person who I bet knows which replacement drivers are most likely could 
save some effort for many people who otherwise may have to read help on 
a number of drivers (naming is not always obvious), or grep through the 
driver source for board or chipset names giving a clue.

If Kconfig can't do this, fine, I haven't studied it in years, nor ever 
been an expert. If you have no idea what drivers replace the ones you 
are deleting and are only following orders, fine too (but I doubt that). 
But no improvement to ALSA help text would save as many people as much 
time as a one line message telling them the most likely driver to 
support similar hardware and avoiding the need to look at that text, or 
at least let the cautious look as the most likely text first.

Since you are the agent of change in breaking many existing configs I 
thought you might be inclined to at least give a clue if it were small 
effort on your part.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

