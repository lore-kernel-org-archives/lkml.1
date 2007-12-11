Return-Path: <linux-kernel-owner+w=401wt.eu-S1754086AbXLKWCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbXLKWCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 17:02:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563AbXLKWB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 17:01:59 -0500
Received: from mga03.intel.com ([143.182.124.21]:5141 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273AbXLKWB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 17:01:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,154,1196668800"; 
   d="scan'208";a="338796125"
Message-ID: <475F084E.3090309@intel.com>
Date: Tue, 11 Dec 2007 13:59:42 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Martin Bligh <mbligh@google.com>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>, netdev@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-rc4-mm1
References: <20071204211701.994dfce6.akpm@linux-foundation.org>	<33307c790712110813h23def95dvd068b7226e9fcd36@mail.gmail.com> <20071211123705.844aac24.akpm@linux-foundation.org> <475F00A2.6020406@intel.com>
In-Reply-To: <475F00A2.6020406@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Dec 2007 22:00:16.0530 (UTC) FILETIME=[36853720:01C83C41]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kok, Auke wrote:
> Andrew Morton wrote:
>> On Tue, 11 Dec 2007 08:13:52 -0800 "Martin Bligh" <mbligh@google.com> wrote:
>>
>>>> - Lots of device IDs have been removed from the e1000 driver and moved
>>>> over
>>>>  to e1000e.  So if your e1000 stops working, you forgot to set
>>>> CONFIG_E1000E.
>>>>
>>>>
>>> Wouldn't it make sense to just default this to on if E1000 was on, rather
>>> than screwing
>>> everybody for no good reason (plus breaking all the automated testing, etc
>>> etc)?
>>> Much though I love random refactoring, it is fairly painful to just keep
>>> changing the
>>> names of things.
>> (cc netdev and Auke)
>>
>> Yes, that would be very sensible.  CONFIG_E1000E should default to whatever
>> CONFIG_E1000 was set to.
> 
> which is "y" for x86 and friends, ppc, arm and ia64 through 'defconfig'. the
> Kconfig files do not have defaults in them.
> 
> I can send a patch to adjust the defconfig files, would that be OK? I certainly
> think that would be reasonable, I dislike setting defaults through defconfig for
> network drivers myself and rather would not do that.

that should read "dislike setting defaults through Kconfig ..."

Auke
