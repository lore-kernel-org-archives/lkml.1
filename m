Return-Path: <linux-kernel-owner+w=401wt.eu-S1762464AbXEVHSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762464AbXEVHSE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 03:18:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755315AbXEVHRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 03:17:54 -0400
Received: from ppsw-9.csi.cam.ac.uk ([131.111.8.139]:60208 "EHLO
	ppsw-9.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185AbXEVHRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 03:17:54 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
In-Reply-To: <20070522042811.GA3852@havoc.gtf.org>
References: <20070522042811.GA3852@havoc.gtf.org>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <BDA4331E-B2F3-44BF-AC30-4E631AEF92DA@cam.ac.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: [PATCH] partitions/LDM: build fix
Date: Tue, 22 May 2007 08:17:41 +0100
To: Jeff Garzik <jeff@garzik.org>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 May 2007, at 05:28, Jeff Garzik wrote:
> This from a "tested" patch...

I had already posted a fix earlier:

	From: 	  Anton Altaparmakov <aia21@cam.ac.uk>
	Subject: 	Fix to the fix! - Re: [2.6 PATCH] LDM: Fix for Windows  
Vista dynamic disks
	Date: 	21 May 2007 21:13:37 BDT

> Signed-off-by: Jeff Garzik <jeff@garzik.org>
>
> diff --git a/fs/partitions/ldm.c b/fs/partitions/ldm.c
> index c387812..99873a2 100644
> --- a/fs/partitions/ldm.c
> +++ b/fs/partitions/ldm.c
> @@ -158,7 +158,7 @@ static bool ldm_parse_privhead(const u8 *data,  
> struct privhead *ph)
>  		/* Warn the user and continue, carefully. */
>  		ldm_info("Database is normally %u bytes, it claims to "
>  			"be %llu bytes.", LDM_DB_SIZE,
> -			udunsigned long long)ph->config_size);
> +			(unsigned long long)ph->config_size);
>  	}
>  	if ((ph->logical_disk_size == 0) || (ph->logical_disk_start +
>  			ph->logical_disk_size > ph->config_start)) {

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/


