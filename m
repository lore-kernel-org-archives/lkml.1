Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab0BEMOq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 07:14:46 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:42075 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755262Ab0BEMOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 07:14:45 -0500
Date: Fri, 5 Feb 2010 13:14:43 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, stable@kernel.org, mikem@beardog.cce.hp.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cciss: Make cciss_seq_show handle holes in the
	h->drv[] array.
Message-ID: <20100205121443.GF1025@kernel.dk>
References: <20100204224929.12371.65766.stgit@beardog.cce.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100204224929.12371.65766.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 04 2010, Stephen M. Cameron wrote:
> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> 
> cciss: Make cciss_seq_show handle holes in the h->drv[] array.
> It is possible (and expected) for there to be holes in the h->drv[]
> array, that is, some elements may be NULL pointers.  cciss_seq_show
> needs to be made aware of this possibility to avoid an Oops.
> 
> To reproduce the Oops which this fixes:
> 
> 1) Create two "arrays" in the Array Configuratino Utility and
>    several logical drives on each array.
> 2) cat /proc/driver/cciss/cciss* in an infinite loop
> 3) delete some of the logical drives in the first "array."
> 
> Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Thanks Stephen, applied for 2.6.33. BTW, you want to put that stable cc
into the patch itself as well, then it'll get picked up automatically
when Linus merges it.

-- 
Jens Axboe

