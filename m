Return-Path: <linux-kernel-owner+w=401wt.eu-S1758663AbXLKW2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758663AbXLKW2v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 17:28:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758428AbXLKW2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 17:28:07 -0500
Received: from mga02.intel.com ([134.134.136.20]:8143 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757414AbXLKW2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 17:28:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,154,1196668800"; 
   d="scan'208";a="240683418"
Message-ID: <475F0C6C.20900@intel.com>
Date: Tue, 11 Dec 2007 14:17:16 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: mbligh@google.com, linux-kernel@vger.kernel.org, apw@shadowen.org,
       netdev@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
Subject: Re: 2.6.24-rc4-mm1
References: <20071204211701.994dfce6.akpm@linux-foundation.org>	<33307c790712110813h23def95dvd068b7226e9fcd36@mail.gmail.com>	<20071211123705.844aac24.akpm@linux-foundation.org>	<475F00A2.6020406@intel.com> <20071211141040.a1c6f316.akpm@linux-foundation.org>
In-Reply-To: <20071211141040.a1c6f316.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Dec 2007 22:17:49.0806 (UTC) FILETIME=[AA5260E0:01C83C43]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 11 Dec 2007 13:26:58 -0800
> "Kok, Auke" <auke-jan.h.kok@intel.com> wrote:
> 
>> Andrew Morton wrote:
>>> On Tue, 11 Dec 2007 08:13:52 -0800 "Martin Bligh" <mbligh@google.com> wrote:
>>>
>>>>> - Lots of device IDs have been removed from the e1000 driver and moved
>>>>> over
>>>>>  to e1000e.  So if your e1000 stops working, you forgot to set
>>>>> CONFIG_E1000E.
>>>>>
>>>>>
>>>> Wouldn't it make sense to just default this to on if E1000 was on, rather
>>>> than screwing
>>>> everybody for no good reason (plus breaking all the automated testing, etc
>>>> etc)?
>>>> Much though I love random refactoring, it is fairly painful to just keep
>>>> changing the
>>>> names of things.
>>> (cc netdev and Auke)
>>>
>>> Yes, that would be very sensible.  CONFIG_E1000E should default to whatever
>>> CONFIG_E1000 was set to.
>> which is "y" for x86 and friends, ppc, arm and ia64 through 'defconfig'. the
>> Kconfig files do not have defaults in them.
> 
> I wouldn't be looking at defconfig files - I don't think many people use
> them.  Most people use their previous config, via oldconfig.
> 
> So what we want here is to give them E1000E if they had previously been
> using E1000.  I don't know how one would do this in Kconfig.

ditto. I doubt that "SELECT E1000E" would be a good idea here (maybe not even
work), and I can't think of anything else.

Auke
