Return-Path: <linux-kernel-owner+w=401wt.eu-S936377AbXGZUAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936377AbXGZUAm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 16:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933646AbXGZT7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 15:59:46 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:63144 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935842AbXGZT7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 15:59:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=OcZL35OY9jZ1e5ucbMU9EYbixl0jf4M2bEnotEykbLBXNqC8k0ExpR8302xOsS5zTq7JZNGnMf0je0yatHTH2hSsInYxZnct3W2fg7j/dRnbAMhNh1eT9nij5W3XlpPxfUd7r56uBE8/tGUlstEKMfnBvLSfJYusxWuqb9IWaIk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Vitaly Bordug <vitb@kernel.crashing.org>
Subject: Re: [PATCH 1/2] [IDE] Platform IDE driver (was: MMIO IDE driver)
Date: Thu, 26 Jul 2007 21:28:00 +0200
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
References: <20070725165318.5331.23795.stgit@localhost.localdomain>
In-Reply-To: <20070725165318.5331.23795.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707262128.00777.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday 25 July 2007, Vitaly Bordug wrote:
> 
> This is now very similar to pata_platform.c, they both use
> same platform data structure and same resources.
> 
> To achieve that, byte_lanes_swapping platform data variable
> and platform specified iops removed from that driver. It's fine,
> since those were never used anyway.
> 
> pata_platform and ide_platform are carrying same driver names,
> to easily switch between these drivers, without need to touch
> platform code.

Looks really good, thanks for working on this.

> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> Signed-off-by: Vitaly Bordug <vitb@kernel.crashing.org>

applied but it would be also nice to fix minor issues found by Sergei
(please just send a new version of the patch and I will replace this
version with the newer one in my tree)

patch #2/2 also looks fine and when issues raised by Sergei gets
addressed it will be merged

Thanks,
Bart
