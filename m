Return-Path: <linux-kernel-owner+w=401wt.eu-S1759326AbYBXEjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326AbYBXEjZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 23:39:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754513AbYBXEjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 23:39:17 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40824 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754998AbYBXEjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 23:39:16 -0500
Subject: Re: [PATCH] scsi/mvsas.c needs to include linux/ctype.h fo isalnum
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Ke Wei <kewei@marvell.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080224152700.20365867.sfr@canb.auug.org.au>
References: <20080224152700.20365867.sfr@canb.auug.org.au>
Content-Type: text/plain
Date: Sat, 23 Feb 2008 22:39:11 -0600
Message-Id: <1203827951.3139.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-02-24 at 15:27 +1100, Stephen Rothwell wrote:
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/scsi/mvsas.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> Discovered while compiling Linus' tree in preparation for today's linux-next.
> 
> diff --git a/drivers/scsi/mvsas.c b/drivers/scsi/mvsas.c
> index 30e20e6..de762f4 100755
> --- a/drivers/scsi/mvsas.c
> +++ b/drivers/scsi/mvsas.c
> @@ -35,6 +35,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/delay.h>
>  #include <linux/dma-mapping.h>
> +#include <linux/ctype.h>

In future, it would be nice if you could send SCSI patches to the SCSI
list: linux-scsi@vger.kernel.org

But actually, a more complete version of this one is already upstream as
commit 0a3716eb04ccfdbef6e872a343ba7ce309237e79

James


