Return-Path: <linux-kernel-owner+w=401wt.eu-S1753729AbZKGW7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbZKGW7s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 17:59:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753489AbZKGW7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 17:59:46 -0500
Received: from mga12.intel.com ([143.182.124.36]:42998 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753460AbZKGW7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 17:59:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,701,1249282800"; 
   d="scan'208";a="208893758"
Message-ID: <4AF5FBC7.9000105@linux.intel.com>
Date: Sat, 07 Nov 2009 16:59:19 -0600
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
References: <1257537660-5301-1-git-send-email-lrodriguez@atheros.com> <200911072152.57596.trenn@suse.de> <4AF5F47C.5000402@linux.intel.com> <200911072347.05786.trenn@suse.de>
In-Reply-To: <200911072347.05786.trenn@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> in addition, most FSB systems have the memory controller in the chipset,
>> next to the PCI logic... so that the FSB bus for DMA transactions only
>> carries the snoop traffic, not the whole data.
> So when should people look at this?

at this point the atheros folks haven't even confirmed that this is the cause...

I'm not saying that the linux behavior is optimal with P states (I have a rather
sizeable algorithm rewrite in the queue) but to blame anything and everything on
a half-speed FSB during a very idle system?
I'm still somewhat skeptical. Again.. the CPU is basically idle here (otherwise
ondemand would ramp the freq up quickly); at which point the FSB traffic mostly is
just cache coherency traffic.... much less bandwidth intensive.
