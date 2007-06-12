Return-Path: <linux-kernel-owner+w=401wt.eu-S1757759AbXFLDSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757759AbXFLDSi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 23:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753007AbXFLDS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 23:18:28 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:51143 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752581AbXFLDS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 23:18:27 -0400
Message-ID: <466E1080.4070504@garzik.org>
Date: Mon, 11 Jun 2007 23:18:24 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Tejun Heo <htejun@gmail.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       james.bottomley@steeleye.com, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/3] AHCI Link Power Management
References: <20070611114600.7fca1c24.kristen.c.accardi@intel.com> <466DFDB5.9030901@gmail.com> <466E0642.5020506@linux.intel.com> <466E0F30.3000700@garzik.org> <466E0F28.3040701@linux.intel.com>
In-Reply-To: <466E0F28.3040701@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> Jeff Garzik wrote:
>> SATA standard defines lower power phy states.  So the same argument 
>> you're using for AHCI applies there too -- "just" enabling an existing 
>> hardware feature.

> yes I'm not arguing against that. I was trying to find out (and 
> suggest-unless-proven-otherwise) that the 2 are not exclusive or 
> conflicting... in fact I assume both are wanted concurrently.

Yes and no.  As I understand it, AHCI's capability is an automatic 
version of what standard SATA phys provide manually.  In AHCI's case, 
the hardware automatically manages the link power, possibly cycling it 
hundreds of times per second.  In the standard case, software must 
determine when a different power state is appropriate based on current 
conditions, and update the phy appropriately.

	Jeff



