Return-Path: <linux-kernel-owner+w=401wt.eu-S1754825AbXL2LuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbXL2LuJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 06:50:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbXL2Lt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 06:49:58 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:54297 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949AbXL2Lt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 06:49:57 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47763450.5010604@s5r6.in-berlin.de>
Date: Sat, 29 Dec 2007 12:49:36 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Dave Young <hidave.darkstar@gmail.com>
CC: khali@linux-fr.org, linux-kernel@vger.kernel.org, i2c@lm-sensors.org
Subject: Re: [PATCH 04/12] i2c : Use mutex instead of semaphore in driver
 core
References: <20071229010751.GE2883@darkstar.te-china.tietoenator.com>
In-Reply-To: <20071229010751.GE2883@darkstar.te-china.tietoenator.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Young wrote:
> --- linux/drivers/i2c/i2c-core.c	2007-12-28 10:06:58.000000000 +0800
> +++ linux.new/drivers/i2c/i2c-core.c	2007-12-28 10:08:58.000000000 +0800
> @@ -33,8 +33,8 @@
>  #include <linux/platform_device.h>
>  #include <linux/mutex.h>
>  #include <linux/completion.h>
> +#include <linux/mutex.h>
>  #include <asm/uaccess.h>
> -#include <asm/semaphore.h>

2x #include <linux/mutex.h>
-- 
Stefan Richter
-=====-=-=== ==-- ===-=
http://arcgraph.de/sr/
