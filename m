Return-Path: <linux-kernel-owner+w=401wt.eu-S1753400AbZDFFsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbZDFFsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 01:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbZDFFsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 01:48:08 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:40537 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872AbZDFFsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 01:48:07 -0400
Message-ID: <49D99775.9030104@garzik.org>
Date: Mon, 06 Apr 2009 01:47:33 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Mark Lord <lkml@rtr.ca>, Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [GIT PULL] Ext3 latency fixes
References: <alpine.LFD.2.00.0904031150190.4015@localhost.localdomain>	<alpine.LFD.2.00.0904031329410.7007@localhost.localdomain>	<20090404135719.GA9812@mit.edu>	<20090404151649.GE5178@kernel.dk>	<alpine.LFD.2.00.0904040854470.3915@localhost.localdomain>	<20090404173412.GF5178@kernel.dk>	<alpine.LFD.2.00.0904041039230.3915@localhost.localdomain>	<20090404180108.GH5178@kernel.dk>	<20090404232222.GA7480@mit.edu>	<20090404163349.20df1208@infradead.org>	<20090405001005.GA7553@mit.edu>	<alpine.LFD.2.00.0904050927580.4023@localhost.localdomain>	<49D8E71F.6000703@rtr.ca>	<49D91B31.90300@garzik.org> <20090405164831.7ad01c20@infradead.org>
In-Reply-To: <20090405164831.7ad01c20@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Sun, 05 Apr 2009 16:57:21 -0400
> Jeff Garzik <jeff@garzik.org> wrote:
>> We set it in libata-scsi.c:ata_scsi_dev_config() based on
>> ata_id_is_ssd()
>>
>> That hueristic probably assumes Intel SSDs or something :/
> 
> you mean the "rpm" set to '1' ?
> I was pretty sure that that was industry standard...

A -new- industry standard.  You can certainly create a compliant SSD 
while only conforming to ATA-7, for example.  Some older IDE flash 
devices pretend they are normal hard drives in almost every respect, too.

	Jeff



