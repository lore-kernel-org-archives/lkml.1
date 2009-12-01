Return-Path: <linux-kernel-owner+w=401wt.eu-S1753296AbZLAGkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbZLAGkZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 01:40:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbZLAGkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 01:40:24 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:43639 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbZLAGkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 01:40:23 -0500
Message-ID: <4B14BA40.7040500@oracle.com>
Date: Mon, 30 Nov 2009 22:40:00 -0800
From: Randy Dunlap <randy.dunlap@Oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@Oracle.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-media@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH -next] media/common/tuners: fix use of KERNEL_VERSION
References: <4B14B8F1.6000805@oracle.com>
In-Reply-To: <4B14B8F1.6000805@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4B14BA54.00A0:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> pms.c uses KERNEL_VERSION so it needs to include version.h.

Incorrect $subject, sorry.

> drivers/media/video/pms.c:682: error: implicit declaration of function 'KERNEL_VERSION'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/media/video/pms.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-next-20091130.orig/drivers/media/video/pms.c
> +++ linux-next-20091130/drivers/media/video/pms.c
> @@ -29,6 +29,7 @@
>  #include <linux/mm.h>
>  #include <linux/ioport.h>
>  #include <linux/init.h>
> +#include <linux/version.h>
>  #include <asm/io.h>
>  #include <linux/videodev2.h>
>  #include <media/v4l2-common.h>


-- 
~Randy
