Return-Path: <linux-kernel-owner+w=401wt.eu-S1756593AbYFQQ5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593AbYFQQ5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 12:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754046AbYFQQ5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 12:57:08 -0400
Received: from brick.kernel.dk ([87.55.233.238]:28220 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753962AbYFQQ5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 12:57:06 -0400
Date: Tue, 17 Jun 2008 18:57:02 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0 of 3] Block Layer Data Integrity
Message-ID: <20080617165701.GN20851@kernel.dk>
References: <patchbomb.1213718275@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <patchbomb.1213718275@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17 2008, Martin K. Petersen wrote:
> 
> These patches allow data integrity information (checksum and more) to
> be attached to I/Os at the block/filesystem layers and transferred
> through the entire I/O stack all the way to the physical storage
> device.
> 
> The integrity metadata can be generated in close proximity to the
> original data.  Capable host adapters, RAID arrays and physical disks
> can verify the data integrity and abort I/Os in case of a mismatch.
> 
> Changes:
> 
>  - Add "if in doubt" to Kconfig
> 
>  - Make blk_rq_count_integrity_sg() more readable
> 
>  - Queue integrity sysfs fixes
> 
>  - Fix two struct bi leaks
> 
>  - Rename struct bip to bio_integrity_payload
> 
>  - Introduce bio_integrity_hw_sectors() that converts from block layer
>    (512b) sectors to hardware sectors
> 
>  - Fix kunmap_atomic() abuse
> 
>  - Replace ?: constructs with if()
> 
>  - Add __GFP_NOFAIL to bio_integrity_prep() allocation

Thanks Martin, looks good to me now. Applied to pending 2.6.27 queue.

-- 
Jens Axboe

