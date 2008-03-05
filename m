Return-Path: <linux-kernel-owner+w=401wt.eu-S1752632AbYCENcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbYCENcY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 08:32:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751053AbYCENcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 08:32:13 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:35418 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbYCENcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 08:32:12 -0500
Date: Wed, 5 Mar 2008 15:32:09 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/9] scsi: replace __inline with inline
Message-ID: <20080305133209.GA24165@cs181133002.pp.htv.fi>
References: <1204679836.5698.67.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1204679836.5698.67.camel@brick>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2008 at 05:17:16PM -0800, Harvey Harrison wrote:
>...
> --- a/drivers/scsi/aic7xxx/aic79xx_core.c
> +++ b/drivers/scsi/aic7xxx/aic79xx_core.c
> @@ -268,7 +268,7 @@ static int		ahd_match_scb(struct ahd_softc *ahd, struct scb *scb,
>  
>  /******************************** Private Inlines *****************************/
>  
> -static __inline void
> +static inline void
>  ahd_assert_atn(struct ahd_softc *ahd)
>  {
>  	ahd_outb(ahd, SCSISIGO, ATNO);
>...

inline's in .c files in the kernel are in 99,9% of all cases the wrong 
thing, so when you anyway touch this code you cold as well remove them.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

