Return-Path: <linux-kernel-owner+w=401wt.eu-S1758403AbZDFNNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758403AbZDFNNd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 09:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755219AbZDFNNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 09:13:23 -0400
Received: from baikonur.stro.at ([213.239.196.228]:51537 "EHLO
	baikonur.stro.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756435AbZDFNNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 09:13:21 -0400
Date: Mon, 6 Apr 2009 15:12:43 +0200
From: maximilian attems <max@stro.at>
To: Mithlesh Thukral <mithlesh@linsyssoft.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       debian-kernel@lists.debian.org
Subject: Re: Staging: sxg: slicoss: Specify the license for Sahara SXG and
	Slicoss drivers
Message-ID: <20090406131243.GD4442@stro.at>
Mail-Followup-To: Mithlesh Thukral <mithlesh@linsyssoft.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	debian-kernel@lists.debian.org
References: <200904051944.n35JifSg018472@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904051944.n35JifSg018472@hera.kernel.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 05 Apr 2009, Linux Kernel Mailing List wrote:

> Gitweb:     http://git.kernel.org/linus/ba0e1ebb7ea0616eebc29d2077355bacea62a9d8
> Commit:     ba0e1ebb7ea0616eebc29d2077355bacea62a9d8
> Parent:     19be358212af35bd64d449da82279874099a1a85
> Author:     Mithlesh Thukral <mithlesh@linsyssoft.com>
> AuthorDate: Wed Mar 25 15:52:54 2009 +0530
> Committer:  Greg Kroah-Hartman <gregkh@suse.de>
> CommitDate: Fri Apr 3 14:54:38 2009 -0700
> 
>     Staging: sxg: slicoss: Specify the license for Sahara SXG and Slicoss drivers
>     
>     Specify a license for the Alacritech Sahara (10Gbe) and SLICOSS (1GBE)
>     firmware files.
>     
>     Signed-off-by: Christopher Harrer <charrer@alacritech.com>
>     Signed-off-by: Mithlesh Thukral <mithlesh@linsyssoft.com>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  firmware/WHENCE |   33 ++++++++++++++++++++++++++++++---
>  1 files changed, 30 insertions(+), 3 deletions(-)
> 
> diff --git a/firmware/WHENCE b/firmware/WHENCE
> index df79422..d6c227d 100644
> --- a/firmware/WHENCE
> +++ b/firmware/WHENCE
> @@ -372,7 +372,21 @@ File: slicoss/oasisdbgdownload.sys.ihex
>  File: slicoss/oasisdownload.sys.ihex
>  File: slicoss/oasisrcvucode.sys.ihex
>  
> -Licence: Unknown
> +Licence:
> +		Copyright (C) 1999-2009 Alacritech, Inc.
> +
> +	as an unpublished work. This notice does not imply unrestricted or
> +	public access to the source code from which this firmware image is
> +	derived.  Except as noted below this firmware image may not be
> +	reproduced, used, sold or transferred to any third party without
> +	Alacritech's prior written consent.  All Rights Reserved.
> +
> +	Permission is hereby granted for the distribution of this firmware
> +	image as part of a Linux or other Open Source operating system kernel
> +	in text or binary form as required.
> +
> +	This firmware may not be modified and may only be used with
> +	Alacritech hardware.

have you read what you say?

the last paragraph disables the distribution right,
due beeing only allowed to be touched on alacritech hardware.

i'm certainly not buying anything from alacritech,
but would want to disbribute your fimware in Debian
in the nonfree firmware-linux package for the benefit
of your customers.
-> http://packages.debian.org/sid/firmware-linux
  
>  Found in hex form in kernel source.
>  
> @@ -383,10 +397,23 @@ Driver: SXG - Alacritech IS-NIC products
>  File: sxg/saharadownloadB.sys.ihex
>  File: sxg/saharadbgdownloadB.sys.ihex
>  
> -Licence: Unknown
> +Licence:
> +		Copyright (C) 1999-2009 Alacritech, Inc.
> +
> +	as an unpublished work. This notice does not imply unrestricted or
> +	public access to the source code from which this firmware image is
> +	derived.  Except as noted below this firmware image may not be
> +	reproduced, used, sold or transferred to any third party without
> +	Alacritech's prior written consent.  All Rights Reserved.
> +
> +	Permission is hereby granted for the distribution of this firmware
> +	image as part of a Linux or other Open Source operating system kernel
> +	in text or binary form as required.
> +
> +	This firmware may not be modified and may only be used with
> +	Alacritech hardware.

same trouble,
nuke the "and may only be used with Alacritech hardware."


-- 
maks
