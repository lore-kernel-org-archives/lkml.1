Return-Path: <linux-kernel-owner+w=401wt.eu-S1754914AbXLKVaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbXLKVaL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 16:30:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbXLKV3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 16:29:55 -0500
Received: from mga02.intel.com ([134.134.136.20]:35443 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848AbXLKV3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 16:29:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,154,1196668800"; 
   d="scan'208";a="293840364"
Message-ID: <475F00A2.6020406@intel.com>
Date: Tue, 11 Dec 2007 13:26:58 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Martin Bligh <mbligh@google.com>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>, netdev@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-rc4-mm1
References: <20071204211701.994dfce6.akpm@linux-foundation.org>	<33307c790712110813h23def95dvd068b7226e9fcd36@mail.gmail.com> <20071211123705.844aac24.akpm@linux-foundation.org>
In-Reply-To: <20071211123705.844aac24.akpm@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Dec 2007 21:27:32.0163 (UTC) FILETIME=[A3AA9930:01C83C3C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 11 Dec 2007 08:13:52 -0800 "Martin Bligh" <mbligh@google.com> wrote:
> 
>>>
>>> - Lots of device IDs have been removed from the e1000 driver and moved
>>> over
>>>  to e1000e.  So if your e1000 stops working, you forgot to set
>>> CONFIG_E1000E.
>>>
>>>
>> Wouldn't it make sense to just default this to on if E1000 was on, rather
>> than screwing
>> everybody for no good reason (plus breaking all the automated testing, etc
>> etc)?
>> Much though I love random refactoring, it is fairly painful to just keep
>> changing the
>> names of things.
> 
> (cc netdev and Auke)
> 
> Yes, that would be very sensible.  CONFIG_E1000E should default to whatever
> CONFIG_E1000 was set to.

which is "y" for x86 and friends, ppc, arm and ia64 through 'defconfig'. the
Kconfig files do not have defaults in them.

I can send a patch to adjust the defconfig files, would that be OK? I certainly
think that would be reasonable, I dislike setting defaults through defconfig for
network drivers myself and rather would not do that.

Auke
