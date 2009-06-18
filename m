Return-Path: <linux-kernel-owner+w=401wt.eu-S1762483AbZFRPbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762483AbZFRPbY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 11:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756075AbZFRPbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 11:31:16 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:54605 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754593AbZFRPbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 11:31:15 -0400
Message-ID: <4A3A5DD0.6060805@garzik.org>
Date: Thu, 18 Jun 2009 11:31:28 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: open-osd mailing-list <osd-dev@open-osd.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [osd-dev] [PATCHSET 0/6] exofs: few patches for Linux 2.6.31
References: <4A391373.3050301@panasas.com> <4A3A370D.10704@panasas.com>
In-Reply-To: <4A3A370D.10704@panasas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh wrote:
> On 06/17/2009 07:01 PM, Boaz Harrosh wrote:
>>   [PATCH 5/6] osdblk: a Linux block device for OSD objects
>>   [PATCH 6/6] osdblk: Adjust queue limits to lower device's limits
>>
>> 	This is the proposed osdblk driver by Jeff Garzik. It as all the Kernel
>> 	pre-requisites, but is missing a user-mode tool and more testing. So I'm
>> 	not sure it will make it into this Kernel. But for review.
>>
> 
> Jeff hi.
> 
> I've hacked up a very quick and dirty small utility for Creating / Removing / Resizing
> objects on an OSD device. [I'm sending as reply to this mail]

Looks good to me!


> Please give it a fast testing. Should we now submit the osdblk driver, for 2.6.31?
> Which tree? I can push it through the open-osd.org tree. The driver was included for
> some weeks in linux-next through that tree.

I'll try to give it a test early next week, as my OSD simulator setup is 
completely disassembled at the moment.

Yes, please go ahead and push the driver.  In general, Linus accepts new 
drivers to the kernel at any time, even during a -rc, once the pre-reqs 
are upstream.

	Jeff



