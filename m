Return-Path: <linux-kernel-owner+w=401wt.eu-S934675AbXGMO7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934675AbXGMO7Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 10:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759536AbXGMO7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 10:59:16 -0400
Received: from rtr.ca ([64.26.128.89]:4741 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757394AbXGMO7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 10:59:15 -0400
Message-ID: <46979342.3030203@rtr.ca>
Date: Fri, 13 Jul 2007 10:59:14 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Ingo Freund <linux-kernel-news@e-dict.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: howto create partitions bigger than 2TB
References: <4697760E.4070803@e-dict.net>
In-Reply-To: <4697760E.4070803@e-dict.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Freund wrote:
> Hi
> 
> I've got a RAID5 (driver aacraid for an ICP9047MA) with four
> 750GB hdds which provides a 2.25TB sized device.
> None of the until now used tools will work with that device.
> fdisk complains about missing cylinder count.
> cfdisk misses the device size.
> parted shows the right device size but only creates a partion
> with 51GB.
> What am I supposed to do to work with this device?

Create a single RAID which covers the entire drive set
(as it sounds like you have already done).

Then use LVM on top of that, instead of conventional partitions.

-ml
