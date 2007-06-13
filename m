Return-Path: <linux-kernel-owner+w=401wt.eu-S1755722AbXFMStx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722AbXFMStx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 14:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754085AbXFMSto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 14:49:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:43902 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754073AbXFMStn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 14:49:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,417,1175497200"; 
   d="scan'208";a="256495709"
Message-ID: <46703C44.1000204@intel.com>
Date: Wed, 13 Jun 2007 11:49:40 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070420)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: holzheu <holzheu@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, akpm@osdl.org, mtk-manpages@gmx.net,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Subject: Re: [RFC/PATCH] Documentation of kernel messages
References: <1181747217.29512.9.camel@localhost.localdomain> <20070613175147.GB14355@suse.de> <1181758680.26375.25.camel@localhost.localdomain> <20070613183200.GA16588@suse.de>
In-Reply-To: <20070613183200.GA16588@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Jun 2007 18:49:41.0711 (UTC) FILETIME=[9A118DF0:01C7ADEB]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Wed, Jun 13, 2007 at 08:18:00PM +0200, holzheu wrote:
>> Hi Greg,
>>
>>> Ick, why are you ignoring what we have already with dev_printk() and
>>> friends?  We are just finally getting developers to use that, I think it
>>> will be almost impossible to get people to change to something else,
>>> especially one that isn't even as "correct" as what dev_printk() offers
>>> you today, will be quite hard.
>>>
>>> So, why not use what we already have and work off of it?
>> dev_printk() and friends are great, since they already define something
>> like KMSG_COMPONENT: The driver name.
> 
> They provide way more than that, they also provide the explicit device
> that is being discussed, as well as other things depending on the
> device.
> 
> So if you are going to do this, please use the already-in-place macros
> to hook into, don't try to get the driver authors to pick up something
> new and different, as it's going to be _very_ difficult, trust me...

absolutely... I'm currently trying to convince everyone to get a generic 
netdevice-centric printk macro (dev_printk does not print the interface name, 
which the netdevice can't store locally since it can change) in and even that is 
a pain :)

Auke
