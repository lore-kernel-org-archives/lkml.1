Return-Path: <linux-kernel-owner+w=401wt.eu-S1763349AbXESFSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763349AbXESFSk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 01:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755574AbXESFSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 01:18:33 -0400
Received: from ns.armcci.am ([195.250.88.164]:51778 "EHLO ns.armcci.am"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754746AbXESFSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 01:18:30 -0400
Date: Sat, 19 May 2007 10:18:20 +0500 (AMST)
From: eugene@ns.armcci.am
To: Chris Snook <csnook@redhat.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: ht CPU flag
In-Reply-To: <464E03C5.6040507@redhat.com>
Message-ID: <Pine.LNX.4.64.0705190858590.29910@ns.armcci.am>
References: <Pine.LNX.4.64.0705182131030.25685@ns.armcci.am>
 <464DFBE0.5060904@redhat.com> <Pine.LNX.4.64.0705190023420.25685@ns.armcci.am>
 <464E03C5.6040507@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2007, Chris Snook wrote:

> eugene@ns.armcci.am wrote:
>>
>>
>>  On Fri, 18 May 2007, Chris Snook wrote:
>> 
>> >  eugene@ns.armcci.am wrote:
>> > >   --------------------------------------------------------------------------- 
>> > > 
>> > > 
>> > >   I have Pentium D CPU, which many Windows utilities like cpuz, wcpuid,
>> > >   everest identify as D 930 (Dual Core, 3GHz). From Intel site I find 
>> > >   out
>> > >   that it has no HT feature, nor Windows XP identify it as HT.
>> > > 
>> > >   Why do I have "ht" flag in cpuinfo?
>> > >   -----------------------------------
>> > 
>> >  The "ht" flag merely means "I know how to report hyperthreaded logical 
>> >  processors if I have them."  My Woodcrest Xeon 5110 and my Athlon64 X2 
>> >  both have the "ht" flag, and correctly report the zero hyperthreaded 
>> >  logical processors they each have.
>> > 
>> >      -- Chris
>> > 
>> >
>>
>>  Thanks, Chris.
>>
>>  Am I right that is chipset on mainboard, who is saying - "I know....", not
>>  CPU itself? Is it better to switch off HT support in BIOS?
>>  Is it possible to generate CPU name as: "Pentium D 930" in /proc/cpuinfo?
>>  On the other server I have some 2GHz HT Xeons which can't be identified on
>>  Intel site because of strange naming pattern.
>>  I tried to find any utility for Linux to solve this, but it looks like
>>  everybody are using /pros/cpuinfo, which is not enough :)
>>
>>  Regards, Eugene.
>
> While the BIOS can disable HT, the ability to *report* HT or the lack thereof 
> is within the CPU itself.  I doubt my socket AM2 board has the faintest clue 
> what HT is.
>
> As for human-readable names, the model name in /proc/cpuinfo comes from the 
> processor name string, and includes however much or little information the 
> vendor thinks the lay user wants to know.  If you want more detail, you can 
> always interpret the model, stepping, and other related fields to determine 
> the model number.
>
> If you don't want to manually look up model info on a CPU version table, 
> x86info and dmidecode will give you more information.
>
> 	-- Chris
>

As I already told, there is no stepping 4 for Xeons on Intel site! So 
/proc/cpuinfo, dmidecode, x86info are all wrong.
Moreover, x86info is too old and can't work with /sys fs.

Also Linux is poor on giving FSB and Memory frequency, which I need to be 
sure that memory timing is correct (SPD gives slower parameters then are 
on SDRAM labels :( ).
