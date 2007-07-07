Return-Path: <linux-kernel-owner+w=401wt.eu-S1754707AbXGGTVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbXGGTVP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 15:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbXGGTVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 15:21:01 -0400
Received: from smtp-106-saturday.nerim.net ([62.4.16.106]:61398 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752694AbXGGTVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 15:21:00 -0400
Date: Sat, 7 Jul 2007 21:22:28 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: r.marek@assembler.cz, mhoffman@lightlink.com, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [2.6 patch] make coretemp_device_remove() static
Message-ID: <20070707212228.1e776ff8@hyperion.delvare>
In-Reply-To: <20070705232306.GY3492@stusta.de>
References: <20070705232306.GY3492@stusta.de>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

On Fri, 6 Jul 2007 01:23:06 +0200, Adrian Bunk wrote:
> coretemp_device_remove() can become static.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Obviously correct.

Acked-by: Jean Delvare <khali@linux-fr.org>

> ---
> --- linux-2.6.22-rc6-mm1/drivers/hwmon/coretemp.c.old	2007-07-04 20:46:05.000000000 +0200
> +++ linux-2.6.22-rc6-mm1/drivers/hwmon/coretemp.c	2007-07-04 20:46:20.000000000 +0200
> @@ -318,7 +318,7 @@
>  }
>  
>  #ifdef CONFIG_HOTPLUG_CPU
> -void coretemp_device_remove(unsigned int cpu)
> +static void coretemp_device_remove(unsigned int cpu)
>  {
>  	struct pdev_entry *p, *n;
>  	mutex_lock(&pdev_list_mutex);

Thanks,
-- 
Jean Delvare
