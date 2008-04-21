Return-Path: <linux-kernel-owner+w=401wt.eu-S1755549AbYDUO6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbYDUO6o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 10:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbYDUO6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 10:58:36 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:47294 "EHLO
	outbound6-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752424AbYDUO6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 10:58:35 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-WSS-ID: 0JZOK94-01-Q1C-01
Date: Mon, 21 Apr 2008 09:05:46 -0600
From: Jordan Crouse <jordan.crouse@amd.com>
To: Mitch Bradley <wmb@firmworks.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andres Salomon <dilinger@queued.net>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Joseph Fannin <jfannin@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: OLPC: Add support for calling into Open Firmware
Message-ID: <20080421150546.GB6354@cosmic.amd.com>
References: <20080419031024.GC3503@nineveh.local> <20080418202925.b18452c5.akpm@linux-foundation.org> <20080419092544.378664a8@ephemeral> <20080419133909.5aa6b63e@ephemeral> <86802c440804200334t5cdcd100rfc41e9b1bf379109@mail.gmail.com> <480B321B.5020802@zytor.com> <20080420135948.61bdb4c9@ephemeral> <480B8E9F.8000701@firmworks.com> <480B95B4.5030203@zytor.com> <480C0C5B.2050403@firmworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480C0C5B.2050403@firmworks.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-OriginalArrivalTime: 21 Apr 2008 14:58:23.0129 (UTC) FILETIME=[2515C090:01C8A3C0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/04/08 17:39 -1000, Mitch Bradley wrote:
> H. Peter Anvin wrote:
>> Mitch Bradley wrote:
>>>
>>> The x86 architecture doesn't make this problem easy.
>>>
>>
>> [long rant about the x86 architecture]
>>
>> It would be more useful if you described the actual defined entry 
>> conditions from OpenFirmware look like, including if they are well-defined 
>> for all OF implementations or only for OLPC.
>>
>>     -hpa
>
> Fair enough...
>
> To get the second subquestion out of the way:  At the present time, on the 
> x86 architecture, "all OF implementations" and "OLPC" are effectively the 
> same.  I am unaware of any other x86 OFW deployments in current use.  There 
> have been some in the past, on bespoke systems such as Network Appliance 
> servers and at least one settop box, but those have fallen by the wayside 
> as those companies have shifted over to commodity PC hardware.  The current 
> market status quo is that x86 boards are primarily designed for Windows, 
> and thus must run legacy BIOS, with some recent migration to EFI, neither 
> of which are open source in the strong sense.  While I would like to see 
> more OFW penetration into the larger x86 market, I don't really expect it.  
> x86 motherboard manufacturing is becoming more and more difficult as signal 
> speeds increase, leading to a decline in the number of manufacturers.  The 
> existing manufacturers depend on Windows for sales volume and their 
> internal procedures and working knowledge are based on legacy BIOS.

/me puts on his coreboot hat

This is off topic slightly, but let it be known that the coreboot project
considers OFW a very valid option for x86 platforms.  A kernel that
worked happily with OFW would greatly encourage people to adopt it in
lieu of other BIOS / firmware solutions.

I return you to your previously scheduled debate.

Jordan

