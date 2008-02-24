Return-Path: <linux-kernel-owner+w=401wt.eu-S1759272AbYBXFeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759272AbYBXFeS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 00:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239AbYBXFeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 00:34:05 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:38474 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbYBXFeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 00:34:04 -0500
Message-ID: <47C101C8.2070306@garzik.org>
Date: Sun, 24 Feb 2008 00:34:00 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] [SCSI] gdth: misc cleanups, preparation for	ISA/EISA
 hotplug API
References: <017ac0b5a1e36b990eedfb7124c78d58f947f076.1203828195.git.jeff@garzik.org> <20080224045810.GA17051@infradead.org> <47C0FE1F.300@garzik.org> <20080224053117.GA13904@infradead.org>
In-Reply-To: <20080224053117.GA13904@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Sun, Feb 24, 2008 at 12:18:23AM -0500, Jeff Garzik wrote:
>> hmmmmm.  We'll see how it plays out...  on the remove side, the above is 
>> exact what happens in gdth_remove_one() without my patch, thus 
>> consolidating two cases of the same code into one.  There is a less-strong 
>> argument for doing the allocation that way, but it may turn out to be 
>> useful anyway once the ISA/EISA API conversion is complete.
> 
> EISA ->remove has a different prototype from PCI ->remove from ISA
> ->remove, so gdth_remove_one will be split up eventually.  Having the
> scsi_host_put duplicated in each shouldn't be too much of a problem :)

We'll see what the final result is...  you might turn out to be right. 
If people want to avoid merging this patch because of this issue, that's 
fine.

	Jeff



