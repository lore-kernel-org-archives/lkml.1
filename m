Return-Path: <linux-kernel-owner+w=401wt.eu-S965521AbXCLKoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965521AbXCLKoP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 06:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965526AbXCLKoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 06:44:15 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:63958 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965521AbXCLKoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 06:44:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=qS4sOjLzHYmlJGyMxWT6yUeHN1Bj4D3RVaowIiJccvaqkcM/FRuJmHW9o0x8yAFnetCgxop67P19an57NsSCOsVorXeGVHWO/GiCgJW13Q1zPS51iOYbm9D/BO5orAfvEiw9Sv/cQkHg31wNpk7U4IsJtM71UDp57vm8UDyF7u4=
Message-ID: <84144f020703120344n3f5ed52axf0bc1c109b549535@mail.gmail.com>
Date: Mon, 12 Mar 2007 12:44:12 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Valerie Henson" <val_henson@linux.intel.com>
Subject: Re: [patch 4/4] [TULIP] Rev tulip version
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       "Jeff Garzik" <jeff@garzik.org>
In-Reply-To: <20070312095912.743760000@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070312093128.577087000@linux.intel.com>
	 <20070312095912.743760000@linux.intel.com>
X-Google-Sender-Auth: 22a04db83d4c2ebd
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 3/12/07, Valerie Henson <val_henson@linux.intel.com> wrote:
> --- tulip-2.6-mm-linux.orig/drivers/net/tulip/tulip_core.c
> +++ tulip-2.6-mm-linux/drivers/net/tulip/tulip_core.c
> @@ -17,11 +17,11 @@
>
>  #define DRV_NAME       "tulip"
>  #ifdef CONFIG_TULIP_NAPI
> -#define DRV_VERSION    "1.1.14-NAPI" /* Keep at least for test */
> +#define DRV_VERSION    "1.1.15-NAPI" /* Keep at least for test */
>  #else
> -#define DRV_VERSION    "1.1.14"
> +#define DRV_VERSION    "1.1.15"
>  #endif
> -#define DRV_RELDATE    "May 11, 2002"
> +#define DRV_RELDATE    "Feb 27, 2007"

Why not just drop this? What purpose does a per-module revision have
for in-kernel drivers anyway?

                                      Pekka
