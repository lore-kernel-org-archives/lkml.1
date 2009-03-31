Return-Path: <linux-kernel-owner+w=401wt.eu-S1760027AbZCaOK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760027AbZCaOK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 10:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758769AbZCaOKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 10:10:45 -0400
Received: from exc05vs1.exchange.cysonet.com ([85.158.200.117]:23494 "EHLO
	exc05vs1.exchange.cysonet.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759285AbZCaOKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 10:10:44 -0400
User-Agent: Microsoft-Entourage/12.15.0.081119
Date: Tue, 31 Mar 2009 16:10:38 +0200
Subject: Re: Page Cache writeback too slow,   SSD/noop scheduler/ext2
From: Jos Houtman <jos@hyves.nl>
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Nick Piggin <nickpiggin@yahoo.com.au>, <linux-kernel@vger.kernel.org>,
       Jeff Layton <jlayton@redhat.com>, Dave Chinner <david@fromorbit.com>,
       <linux-fsdevel@vger.kernel.org>, <jens.axboe@oracle.com>,
       <akpm@linux-foundation.org>, <hch@infradead.org>,
       <linux-nfs@vger.kernel.org>
Message-ID: <C5F7F0FE.DED5%jos@hyves.nl>
Thread-Topic: Page Cache writeback too slow,   SSD/noop scheduler/ext2
Thread-Index: Acmx/KJzGrXCkxjyQS217hhdWTGQsQADdT8U
In-Reply-To: <20090331123112.GA15098@localhost>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
X-OriginalArrivalTime: 31 Mar 2009 14:10:39.0649 (UTC) FILETIME=[786B6110:01C9B20A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> There another question I have: does the writeback go through the io
>> scheduler? Because no matter the io scheduler or the tuning done, the
>> writeback algorithm totally starves the reads.
> 
> I noticed this annoying writes-starve-reads problem too. I'll look into it.

Thanks
 
> 
>> Is there anything I can do about this behaviour by creating a better
>> interleaving of the reads and writes?
> 
> I guess it should be handled in the generic block io layer.  Once we
> solved the writes-starve-reads problem, the bursty-writeback behavior
> becomes a no-problem for SSD.

Yeah this was the part where I figured the io-schedulers kicked in, but
obviously I was wrong :P.

If I can do anything more to help this along, let me know.


Thanks

Jos



