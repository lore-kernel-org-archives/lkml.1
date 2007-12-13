Return-Path: <linux-kernel-owner+w=401wt.eu-S1763026AbXLMTEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763026AbXLMTEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 14:04:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754486AbXLMTEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 14:04:05 -0500
Received: from rtr.ca ([76.10.145.34]:4366 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418AbXLMTEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 14:04:01 -0500
Message-ID: <4761821F.3050602@rtr.ca>
Date: Thu, 13 Dec 2007 14:03:59 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jens Axboe <axboe@kernel.dk>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: QUEUE_FLAG_CLUSTER: not working in 2.6.24 ?
References: <47617B92.6020908@rtr.ca> <47617C07.3020501@rtr.ca> <47617E72.6080504@rtr.ca> <20071213185326.GQ26334@parisc-linux.org>
In-Reply-To: <20071213185326.GQ26334@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Thu, Dec 13, 2007 at 01:48:18PM -0500, Mark Lord wrote:
>> Problem confirmed.  2.6.23.8 regularly generates segments up to 64KB for 
>> libata,
>> but 2.6.24 uses only 4KB segments and a *few* 8KB segments.
> 
> Just a suspicion ... could this be slab vs slub?  ie check your configs
> are the same / similar between the two kernels.
..

Mmmm.. a good thought, that one.
But I just rechecked, and both have CONFIG_SLAB=y

My guess is that something got changed around when Jens
reworked the block layer for 2.6.24.
I'm going to dig around in there now.

