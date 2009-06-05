Return-Path: <linux-kernel-owner+w=401wt.eu-S1754158AbZFESyI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbZFESyI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 14:54:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753791AbZFESxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 14:53:25 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:42186 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbZFESxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 14:53:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=O6rzIPfQAzOrZZZWMd4x2F6YtiKT9WFa6/pHhfuIyAwua7rQTUoyDafP0zeb53ZUok
         Cr7kvhh3lmcPjYNtsGK+mnzxscFhKmv6hAyW7izSvzNK7/lJbEPdYMB0+HhBc7IoW8U8
         KE6WSISIquI/nytz6hSZ0c0zOlXdILJsNzJ0w=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Yunpeng Gao <yunpeng.gao@intel.com>
Subject: Re: linux-next: Tree for June 3 (staging)
Date: Fri, 5 Jun 2009 20:45:49 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc8-next-20090604-07237-g030af10; KDE/4.2.3; i686; ; )
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
References: <20090603190952.2dd0cc70.sfr@canb.auug.org.au> <20090603231152.GA18701@suse.de> <20090604232610.GA16053@intel.com>
In-Reply-To: <20090604232610.GA16053@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906052045.49610.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 June 2009 01:26:10 Yunpeng Gao wrote:

[...]

> Subject: [PATCH] First submission of Intel Moorestown platform NAND flash driver
> 
> This driver is a standalone linux block device driver. It acts as
> a normal hard disk. Please reference the README file for the detail.
> 
> Signed-off-by: Gao Yunpeng <yunpeng.gao@intel.com>

[...]

> --- /dev/null
> +++ b/drivers/staging/mrst_nand/Kconfig
> @@ -0,0 +1,27 @@
> +
> +menuconfig MRST_NAND
> +	tristate "Moorestown NAND Flash controller"
> +	depends on BLOCK
> +	default m

New drivers shouldn't be enabled by default.

Please remove the 'default m' line.

Thanks.
Bart
