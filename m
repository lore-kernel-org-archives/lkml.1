Return-Path: <linux-kernel-owner+w=401wt.eu-S933778AbZIDRtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933778AbZIDRtp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 13:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757150AbZIDRto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 13:49:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36351 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbZIDRtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 13:49:43 -0400
Message-ID: <4AA1524F.7030404@zytor.com>
Date: Fri, 04 Sep 2009 10:45:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Dave Jones <davej@redhat.com>, Thomas Renninger <trenn@suse.de>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Gautham R Shenoy <ego@in.ibm.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>, Len Brown <len.brown@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, cpufreq@vger.kernel.org
Subject: Re: [RFC][PATCH 10/14] x86: generic aperf/mperf code.
References: <20090903132145.482814810@chello.nl>	 <20090903132213.006719409@chello.nl> <200909041119.06979.trenn@suse.de>	 <1252056311.7564.3.camel@twins> <1252056439.7564.4.camel@twins>	 <20090904142212.GA3093@redhat.com> <1252075327.8976.3.camel@laptop>
In-Reply-To: <1252075327.8976.3.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2009 07:42 AM, Peter Zijlstra wrote:
>>
>> any 64-bit cpu that supports it can have a 32bit kernel installed on it.
>> (and a significant number of users actually do this).
> 
> 1) we really should be pushing those people to run 64bit kernels
> 
> [ I'm still hoping distros will start shipping 64bit kernels and have
>   the bootloader pick the 64bit one when the hardware supports lm ]
> 

FWIW, there is already support in Syslinux to do that.

If what distros want is a single kernel image that can boot into either
mode, that might be an interesting enhancement to wraplinux.

	-hpa

