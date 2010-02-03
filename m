Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab0BCChL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 21:37:11 -0500
Received: from smtp-out2.blueyonder.co.uk ([195.188.213.5]:52020 "EHLO
	smtp-out2.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755435Ab0BCChJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 21:37:09 -0500
Message-ID: <4B68E151.9030505@blueyonder.co.uk>
Date: Wed, 03 Feb 2010 02:37:05 +0000
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.14 Thunderbird/3.0 ThunderBrowse/3.2.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Takashi Iwai <tiwai@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #15144] HDA Intel Audio hang on boot
References: <vZZJKzCUn4G.A.CPB.F7hZLB@chimera> <4B6635F1.8060909@blueyonder.co.uk> <s5h3a1lh2wr.wl%tiwai@suse.de> <201002022140.06721.rjw@sisk.pl>
In-Reply-To: <201002022140.06721.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/10 20:40, Rafael J. Wysocki wrote:
> On Monday 01 February 2010, Takashi Iwai wrote:
>> At Mon, 01 Feb 2010 02:01:21 +0000,
>> Sid Boyce wrote:
>>>
>>> On 01/02/10 00:22, Rafael J. Wysocki wrote:
>>>> This message has been generated automatically as a part of a report
>>>> of recent regressions.
>>>>
>>>> The following bug entry is on the current list of known regressions
>>>> from 2.6.32.  Please verify if it still should be listed and let me know
>>>> (either way).
>>>>
>>>>
>>>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15144
>>>> Subject		: HDA Intel Audio hang on boot
>>>> Submitter	: Sid Boyce <sboyce@blueyonder.co.uk>
>>>> Date		: 2010-01-15 1:24 (17 days old)
>>>> References	: http://marc.info/?l=linux-kernel&m=126351866722507&w=4
>>>>
>>>>
>>>>
>>>
>>> Still not fixed in 2.6.33-rc6. Takashi wrote that the fix was scheduled
>>> for 2.6.33-rc6, but it did not appear.
>>
>> It just slipped from rc6 due to my busy load.
>> The pull request was sent yesterday.
> 
> Linus has already merged it, so I've closed the bug.
> 
> Rafael
> 

I added the line to hda_intel.c in 2.6.33-rc6 as I had oopses in
2.6.33-rc6-git1 that I haven't yet captured.
SND_PCI_QUIRK(0x1043, 0x829c, "ASUS", 0), /* nvidia */
The problem was still there. I shall have a further look later today.
Regards
Sid.
-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

