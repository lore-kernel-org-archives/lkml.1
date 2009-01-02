Return-Path: <linux-kernel-owner+w=401wt.eu-S1757957AbZABKCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957AbZABKCS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 05:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757318AbZABKCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 05:02:05 -0500
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:34618 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755541AbZABKCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 05:02:03 -0500
Date: Fri, 2 Jan 2009 11:01:59 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-s390@vger.kernel.org,
       schwidefsky@de.ibm.com
Subject: Re: [BUILD-FAILURE] next-20081230 - S390 - tape drive fails to
	build with !CONFIG_BLOCK
Message-ID: <20090102100159.GA4730@osiris.boeblingen.de.ibm.com>
References: <20081231033039.f203b59c.sfr@canb.auug.org.au> <20081231112132.GA4268@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081231112132.GA4268@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2008 at 04:51:32PM +0530, Kamalesh Babulal wrote:
> 	next-20081230 randconfig build fails on S390, with CONFIG_BLOCK=n
> 
>  Adding the dependency of CONFIG_BLOCK to CONFIG_S390_TAPE_BLOCK
> 
> Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com
>
> --- a/drivers/s390/char/Kconfig
> +++ b/drivers/s390/char/Kconfig
> @@ -100,7 +100,7 @@ comment "S/390 tape interface support"
> 
>  config S390_TAPE_BLOCK
>  	bool "Support for tape block devices"
> -	depends on S390_TAPE
> +	depends on S390_TAPE && BLOCK

Thank you, added it to our patch queue.
