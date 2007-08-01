Return-Path: <linux-kernel-owner+w=401wt.eu-S1759388AbXHAFzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759388AbXHAFzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 01:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757928AbXHAFzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 01:55:25 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:42063 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757539AbXHAFzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 01:55:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=A5SOdPhzDIyHFBhgbqQ+JA0hNJ7aTXuEN77Tqr3RQPCa2QtFM276JHAxMSY68JoMw9YDEyP97RLlzpZ8/EdT8aBC1M98DX2U9eXwmiJ+px9lM3D1zuJ6RGuDKVi7s8R0unM3RNGtVNUyeiEOnUhnSiSigC8/oqIdxd2aD4fv1OU=
Subject: Re: [PATCH 4/5] x86_64 EFI support -v3: EFI framebuffer driver
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: ak@suse.de, akpm@linux-foundation.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <1185851582.23149.29.camel@caritas-dev.intel.com>
References: <1185851582.23149.29.camel@caritas-dev.intel.com>
Content-Type: text/plain
Date: Wed, 01 Aug 2007 13:55:12 +0800
Message-Id: <1185947712.4688.22.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-31 at 11:13 +0800, Huang, Ying wrote:

> +
> +#include <linux/delay.h>
> +#include <linux/errno.h>
> +#include <linux/fb.h>
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/ioport.h>
> +#include <linux/mm.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/screen_info.h>
> +#include <linux/slab.h>
> +#include <linux/string.h>
> +#include <linux/dmi.h>
> +#include <linux/efi.h>
> +#include <linux/io.h>
> +
> +#include <video/vga.h>
> +

I don't see any problems with this driver, just a few minor nits.

Do you really need all the #include's?
I presume this driver only supports bpp 16 and above?

Tony



