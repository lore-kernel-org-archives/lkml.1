Return-Path: <linux-kernel-owner+w=401wt.eu-S1762412AbZLKUFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762412AbZLKUFB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 15:05:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761921AbZLKUE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 15:04:56 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:41687 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758394AbZLKUE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 15:04:56 -0500
Date: Fri, 11 Dec 2009 12:02:59 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PM: Fix kernel-doc notation
Message-Id: <20091211120259.82de239d.randy.dunlap@oracle.com>
In-Reply-To: <1258877637.4495.45.camel@ht.satnam>
References: <1258877637.4495.45.camel@ht.satnam>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4B22A5A2.00FB:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Nov 2009 13:43:57 +0530 Jaswinder Singh Rajput wrote:

> 
> Fix the following htmldocs warnings:
> 
>   Warning(drivers/base/power/main.c:249): No description found for parameter 'master'
>   Warning(drivers/base/power/main.c:249): Excess function parameter 'slave' description in 'device_pm_wait_for_slaves'
>   Warning(drivers/base/power/main.c:292): No description found for parameter 'master'
>   Warning(drivers/base/power/main.c:292): Excess function parameter 'slave' description in 'device_pm_check_slaves'
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Randy Dunlap <randy.dunlap@oracle.com>

What tree was this for?
I guess it's not needed now, I can't find these functions..

Thanks.

> ---
>  drivers/base/power/main.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> index e8d1ea6..5f13084 100644
> --- a/drivers/base/power/main.c
> +++ b/drivers/base/power/main.c
> @@ -243,7 +243,7 @@ static void device_pm_wait_for_masters(struct device *slave)
>  
>  /**
>   * device_pm_wait_for_slaves - Wait for all slaves of given device.
> - * @slave: Device to wait for the slaves of.
> + * @master: Device to wait for the slaves of.
>   */
>  static void device_pm_wait_for_slaves(struct device *master)
>  {
> @@ -286,7 +286,7 @@ static int device_pm_check_masters(struct device *slave)
>  
>  /**
>   * device_pm_check_slaves - Check power.op_complete for slaves of a device.
> - * @slave: Device to check the slaves of.
> + * @master: Device to check the slaves of.
>   */
>  static int device_pm_check_slaves(struct device *master)
>  {
> -- 

---
~Randy
