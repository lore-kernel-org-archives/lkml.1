Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933018Ab0BPQI4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 11:08:56 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:27995 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932297Ab0BPQIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 11:08:52 -0500
Message-ID: <4B7AC2A9.4070203@oracle.com>
Date: Tue, 16 Feb 2010 08:07:05 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: khali@linux-fr.org
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] i2c: fix xiic build error
References: <20100204185736.6628ab9a.sfr@canb.auug.org.au> <4B6B29DD.7060502@oracle.com>
In-Reply-To: <4B6B29DD.7060502@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4B7AC2F0.01F9:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/10 12:11, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Add header file to fix build error:
> 
> drivers/i2c/busses/i2c-xiic.c:493: error: implicit declaration of
> function 'mdelay'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/i2c/busses/i2c-xiic.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-next-20100204.orig/drivers/i2c/busses/i2c-xiic.c
> +++ linux-next-20100204/drivers/i2c/busses/i2c-xiic.c
> @@ -31,6 +31,7 @@
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/errno.h>
> +#include <linux/delay.h>
>  #include <linux/platform_device.h>
>  #include <linux/i2c.h>
>  #include <linux/interrupt.h>
> 


This patch is still needed in linux-next-20100216.

-- 
~Randy
