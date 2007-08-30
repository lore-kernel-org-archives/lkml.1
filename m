Return-Path: <linux-kernel-owner+w=401wt.eu-S1762220AbXH3UT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762220AbXH3UT7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 16:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757354AbXH3UTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 16:19:51 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:37991 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167AbXH3UTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 16:19:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Of3vDrF/gbOazzRSOjcSi6fpBpBL66IzeeMjrhHj0vn2OIojk+PE4EMYkHstkQi7NfATljPq1YL6vZ0Uogksr4J/6gsZTh1egx3jSlEjRUTys+m/UkXZbkUMdpCVwmEzTMDdtZjvWSr5oO9Bn/uZRUeTI2+IgqEY/m0G+kxr/FQ=
Message-ID: <524f69650708301319l1c46e56braf38734b4746f24a@mail.gmail.com>
Date: Thu, 30 Aug 2007 15:19:48 -0500
From: "Steve French" <smfrench@gmail.com>
To: kernel-janitors@vger.kernel.org
Subject: Re: Fw: [KJ][patch 2/3] CIFS SMB: use abs() from kernel.h where appropriate
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <OF120A49A9.A12BA37A-ON87257347.004EBCF7-86257347.004ECE3B@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <OF120A49A9.A12BA37A-ON87257347.004EBCF7-86257347.004ECE3B@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Merged into cifs-2.6.git tree.

> From: Andre Haupt <andre@finow14.de>
> Signed-off-by: Andre Haupt <andre@finow14.de>
> ---
> Index: linus/fs/cifs/cifssmb.c
> ===================================================================
> --- linus.orig/fs/cifs/cifssmb.c                 2007-08-30
> 11:43:20.000000000 +0200
> +++ linus/fs/cifs/cifssmb.c              2007-08-30 11:44:58.000000000
> +0200
> @@ -513,7 +513,7 @@ CIFSSMBNegotiate(unsigned int xid, struc
>  (int)ts.tv_sec, (int)utc.tv_sec,
>  (int)(utc.tv_sec - ts.tv_sec)));
>                                                  val = (int)(utc.tv_sec -
> ts.tv_sec);
> -                                                seconds = val < 0 ? -val
> : val;
> +                                                seconds = abs(val);
>                                                  result = (seconds /
> MIN_TZ_ADJ) * MIN_TZ_ADJ;
>                                                  remain = seconds %
> MIN_TZ_ADJ;
>                                                  if (remain >= (MIN_TZ_ADJ
> / 2))
>
> --
>
>


-- 
Thanks,

Steve
