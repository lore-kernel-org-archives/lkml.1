Return-Path: <linux-kernel-owner+w=401wt.eu-S1753285AbZADJDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbZADJDp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 04:03:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750775AbZADJD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 04:03:29 -0500
Received: from vitalin.sorra.shikadi.net ([64.71.152.201]:3886 "EHLO
	vitalin.sorra.shikadi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbZADJD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 04:03:27 -0500
Message-ID: <49607B5B.3070707@shikadi.net>
Date: Sun, 04 Jan 2009 19:03:23 +1000
From: Adam Nielsen <a.nielsen@shikadi.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.8.1.18) Gecko/20081215 Thunderbird/2.0.0.18 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: LKML Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: XFS internal error xfs_da_do_buf(1) at line 2015 of file fs/xfs/xfs_da_btree.c
References: <49600DE6.2080108@shikadi.net> <20090104074659.GA16775@infradead.org>
In-Reply-To: <20090104074659.GA16775@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is a typical result of a power loss scenario with write caches
> enabled and without barriers.  Given that md can't pass through barriers
> did you disable the write caches on your disk?

No, I didn't realise I had to do that...in fact I didn't even realise SATA 
disks *had* write caches, I thought the cache was for reading only...

> Run xfs_repair over it to fix up the directory, and make sure to
> configure your disks properly so that it doesn't happen again..

Will do, thanks for the advice!  Is there any standard way to disable write 
caching on a SATA disk?  hdparm -W seems to do the trick, but then I can't run 
that until the system is up and running, leaving a small window of opportunity 
for something to go wrong.

Thanks again,
Adam.

