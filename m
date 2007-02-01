Return-Path: <linux-kernel-owner+w=401wt.eu-S1422998AbXBAUcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422998AbXBAUcX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 15:32:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422997AbXBAUcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 15:32:23 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47818 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422998AbXBAUcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 15:32:22 -0500
Date: Thu, 1 Feb 2007 20:42:24 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: TJ <linux@tjworld.net>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [PATCH 1/1] filesystem: Disk Errors at boot-time caused by
 probe of partitions
Message-ID: <20070201204224.44d80bcc@localhost.localdomain>
In-Reply-To: <45C23BAA.5050400@cfl.rr.com>
References: <fa.vUjkpPQXmle+uox6D228qG85KCU@ifi.uio.no>
	<45C16AA5.7050808@shaw.ca>
	<1170329269.30563.10.camel@butch.lan.tjworld.net>
	<45C23BAA.5050400@cfl.rr.com>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Feb 2007 14:12:42 -0500
Phillip Susi <psusi@cfl.rr.com> wrote:

> I think you may be barking up the wrong tree because IIRC, these 
> requests for data beyond the end of the disk never make it to the drive; 
> the kernel fails them in the block layer.  There was a patch a while 
> back to fix the partition detection code to NOT request sectors beyond 
> the end of the disk, but I don't think it was ever merged.

ide-scsi and libata support this correctly. Ingo Molnar also ported the
recent CD changes related to size handling. None of these are relevant to
hard disks

> In any case, if you are sure the requests are making it to the drive and 
> causing damage, I hope you give Maxtor and IBM a sound thrashing for 
> using retarded firmware.

All the IBM and Maxtor drives I've played with correctly error when a
sector isn't available. It's pretty implausible they would do otherwise
as the "sector" is a logically mapping onto the drives internal file
system these days.

Fed a wrong sector any drive I know of will report that the sector cannot
be found.
