Return-Path: <linux-kernel-owner+w=401wt.eu-S1756050AbXFLDNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbXFLDNG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 23:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbXFLDMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 23:12:54 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:51089 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752200AbXFLDMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 23:12:53 -0400
Message-ID: <466E0F30.3000700@garzik.org>
Date: Mon, 11 Jun 2007 23:12:48 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Tejun Heo <htejun@gmail.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       james.bottomley@steeleye.com, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/3] AHCI Link Power Management
References: <20070611114600.7fca1c24.kristen.c.accardi@intel.com> <466DFDB5.9030901@gmail.com> <466E0642.5020506@linux.intel.com>
In-Reply-To: <466E0642.5020506@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> Tejun Heo wrote:
>> Kristen Carlson Accardi wrote:
>>> Hi,
>>> This series of patches enables Aggressive Link Power Management for 
>>> AHCI devices, as documented in the AHCI spec.  On my laptop (a Lenovo 
>>> X60), this
>>> saves me a full watt of power.  On other systems, reported power savings
>>> range from .5-1.5 Watts.  It has been tested by the kind folks at 
>>> #powertop
>>> with similar results.  Please give it a try and let me know what you 
>>> think.
>>
>> I'm not sure about this.  We need better PM framework to support
>> powersaving in other controllers and some ahcis don't save much when
>> only link power management is used, 
> 
> do you have data to support this? The data we have from this patch is 
> that it saves typically a Watt of power (depends on the machine of 
> course, but the range is 0.5W to 1.5W). If you want to also have an even 
> more agressive thing where you want to start disabling the entire 
> controller... I don't see how this is in conflict with saving power on 
> the link level by "just" enabling a hardware feature ....

SATA standard defines lower power phy states.  So the same argument 
you're using for AHCI applies there too -- "just" enabling an existing 
hardware feature.

	Jeff


