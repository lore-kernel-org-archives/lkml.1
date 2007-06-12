Return-Path: <linux-kernel-owner+w=401wt.eu-S1757938AbXFLDOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938AbXFLDOa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 23:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753840AbXFLDOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 23:14:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:24348 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757682AbXFLDOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 23:14:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,409,1175497200"; 
   d="scan'208";a="95635817"
Message-ID: <466E0F28.3040701@linux.intel.com>
Date: Mon, 11 Jun 2007 20:12:40 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Tejun Heo <htejun@gmail.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       james.bottomley@steeleye.com, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/3] AHCI Link Power Management
References: <20070611114600.7fca1c24.kristen.c.accardi@intel.com> <466DFDB5.9030901@gmail.com> <466E0642.5020506@linux.intel.com> <466E0F30.3000700@garzik.org>
In-Reply-To: <466E0F30.3000700@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Arjan van de Ven wrote:
>> Tejun Heo wrote:
>>> Kristen Carlson Accardi wrote:
>>>> Hi,
>>>> This series of patches enables Aggressive Link Power Management for 
>>>> AHCI devices, as documented in the AHCI spec.  On my laptop (a 
>>>> Lenovo X60), this
>>>> saves me a full watt of power.  On other systems, reported power 
>>>> savings
>>>> range from .5-1.5 Watts.  It has been tested by the kind folks at 
>>>> #powertop
>>>> with similar results.  Please give it a try and let me know what you 
>>>> think.
>>>
>>> I'm not sure about this.  We need better PM framework to support
>>> powersaving in other controllers and some ahcis don't save much when
>>> only link power management is used, 
>>
>> do you have data to support this? The data we have from this patch is 
>> that it saves typically a Watt of power (depends on the machine of 
>> course, but the range is 0.5W to 1.5W). If you want to also have an 
>> even more agressive thing where you want to start disabling the entire 
>> controller... I don't see how this is in conflict with saving power on 
>> the link level by "just" enabling a hardware feature ....
> 
> SATA standard defines lower power phy states.  So the same argument 
> you're using for AHCI applies there too -- "just" enabling an existing 
> hardware feature.
> 
yes I'm not arguing against that. I was trying to find out (and 
suggest-unless-proven-otherwise) that the 2 are not exclusive or 
conflicting... in fact I assume both are wanted concurrently.
