Return-Path: <linux-kernel-owner+w=401wt.eu-S1753773AbZKGW25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773AbZKGW25 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 17:28:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753542AbZKGW24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 17:28:56 -0500
Received: from mga09.intel.com ([134.134.136.24]:4723 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431AbZKGW24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 17:28:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,701,1249282800"; 
   d="scan'208";a="465291162"
Message-ID: <4AF5F47C.5000402@linux.intel.com>
Date: Sat, 07 Nov 2009 16:28:12 -0600
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>, davej@redhat.com,
       cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org, mcgrof@gmail.com,
       Matthew Garrett <mjg@redhat.com>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Aeolus Yang <Aeolus.Yang@atheros.com>,
       Amod Bodas <Amod.Bodas@atheros.com>,
       David Quan <David.Quan@atheros.com>,
       Kishore Jotwani <Kishore.Jotwani@atheros.com>
Subject: Re: [PATCH] cpu-freq: add troubleshooting section for FSB changes
References: <1257537660-5301-1-git-send-email-lrodriguez@atheros.com> <200911072152.57596.trenn@suse.de>
In-Reply-To: <200911072152.57596.trenn@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Renninger wrote:

[please cut away the part of the mail you're not responding to; your mail was 90% like that]

> On Friday 06 November 2009 09:01:00 pm Luis R. Rodriguez wrote:
>> With cpu frequency scaling you may run into some system
>> performance issues when the FSB changes speed due to the
>> throughput constraints this brings on the system.
> Interesting.
> Could you be a bit more detailed how and what kind of perfomance issues are
> seen, please.
> I expect IO based issues like WLAN package throughput or even lost connections :)

the bus doesn't get THAT slow.....
in addition, most FSB systems have the memory controller in the chipset, next to the PCI
logic... so that the FSB bus for DMA transactions only carries the snoop traffic, not the whole data.


