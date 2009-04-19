Return-Path: <linux-kernel-owner+w=401wt.eu-S1752490AbZDSV2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbZDSV2Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 17:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750944AbZDSV2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 17:28:00 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59154 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902AbZDSV2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 17:28:00 -0400
Message-ID: <49EB9758.3020506@garzik.org>
Date: Sun, 19 Apr 2009 17:27:52 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: =?UTF-8?B?Um9nw6lyaW8gQnJpdG8=?= <rbrito@ime.usp.br>
CC: Michael Tokarev <mjt@tls.msk.ru>, Mark Lord <lkml@rtr.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: Quick question about libata and hdparm
References: <E693AEE4-7895-4650-A1DC-1FB16D409D5B@ime.usp.br> <49EB1A33.7050808@rtr.ca> <49EB1C9C.3000105@msgid.tls.msk.ru> <49EB1FB3.5000609@garzik.org> <20090419201132.GB2891@ime.usp.br>
In-Reply-To: <20090419201132.GB2891@ime.usp.br>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rogério Brito wrote:
> Hi, Jeff.
> 
> On Apr 19 2009, Jeff Garzik wrote:
>> Michael Tokarev wrote:
>>> Well, the kernel does a good job here in *almost* all cases.
>>> The problematic case is when a device has some bad/unreadable
>>> blocks/sectors.  When such a place occurs on read, libata
>>> (or whatever it is) performs several retries, each time
>>> using "less aggressive" settings - like reducing UDMA and
>>> PIO mode till the lowest possible PIO/33.  And the device
>>> stays in that mode until reboot, even if the problematic
>>> sector has been relocated.  So it'd be nice to be able to
>>> reset the mode back in such cases.
>> Do you have a log?
> 
> I have a log here of libata reducing UDMA speed. I don't know if this is
> any hardware problem or not (I think not), but I do see libata
> complaining and reducing the speed of the drive.

Well, it's supposed to reduce speed in several circumstances... just not 
Michael's.  :)

	Jeff



