Return-Path: <linux-kernel-owner+w=401wt.eu-S1753397AbXFLCdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbXFLCdk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 22:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751004AbXFLCda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 22:33:30 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50846 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbXFLCd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 22:33:29 -0400
Message-ID: <466E05F5.3090501@garzik.org>
Date: Mon, 11 Jun 2007 22:33:25 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       james.bottomley@steeleye.com, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com
Subject: Re: [patch 0/3] AHCI Link Power Management
References: <20070611114600.7fca1c24.kristen.c.accardi@intel.com> <466DFDB5.9030901@gmail.com>
In-Reply-To: <466DFDB5.9030901@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Kristen Carlson Accardi wrote:
>> Hi,
>> This series of patches enables Aggressive Link Power Management for AHCI 
>> devices, as documented in the AHCI spec.  On my laptop (a Lenovo X60), this
>> saves me a full watt of power.  On other systems, reported power savings
>> range from .5-1.5 Watts.  It has been tested by the kind folks at #powertop
>> with similar results.  Please give it a try and let me know what you think.
> 
> I'm not sure about this.  We need better PM framework to support
> powersaving in other controllers and some ahcis don't save much when
> only link power management is used, they need to be turned off

A better PM framework would definitely be nice :)


> completely && I don't think scsi sysfs is the right place to export this
> interface.

That's about the only place we have right now.

	Jeff



