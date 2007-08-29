Return-Path: <linux-kernel-owner+w=401wt.eu-S932795AbXH2QZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795AbXH2QZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 12:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757411AbXH2QZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 12:25:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41519 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758307AbXH2QZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 12:25:12 -0400
Message-ID: <46D59DE2.2070405@redhat.com>
Date: Wed, 29 Aug 2007 12:25:06 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: spamtrap@knobisoft.de
CC: linux-kernel@vger.kernel.org, Peter zijlstra <a.p.zijlstra@chello.nl>,
       mingo@redhat.com
Subject: Re: Understanding I/O behaviour - next try
References: <713252.42570.qm@web32614.mail.mud.yahoo.com>
In-Reply-To: <713252.42570.qm@web32614.mail.mud.yahoo.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2007 11:53 AM, Martin Knoblauch wrote:
> 
>  The basic setup is a dual x86_64 box with 8 GB of memory. The DL380
> has a HW RAID5, made from 4x72GB disks and about 100 MB write cache.
> The performance of the block device with O_DIRECT is about 90 MB/sec.
> 
>  The problematic behaviour comes when we are moving large files through
> the system. The file usage in this case is mostly "use once" or
> streaming. As soon as the amount of file data is larger than 7.5 GB, we
> see occasional unresponsiveness of the system (e.g. no more ssh
> connections into the box) of more than 1 or 2 minutes (!) duration
> (kernels up to 2.6.19). Load goes up, mainly due to pdflush threads and
> some other poor guys being in "D" state.

Try booting with "mem=4096M", "mem=2048M", ...
