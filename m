Return-Path: <linux-kernel-owner+w=401wt.eu-S1755278AbXL2Lnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbXL2Lnh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 06:43:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbXL2LnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 06:43:14 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:54104 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbXL2LnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 06:43:13 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <477632AE.2030205@s5r6.in-berlin.de>
Date: Sat, 29 Dec 2007 12:42:38 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Dave Young <hidave.darkstar@gmail.com>
CC: krh@redhat.com, linux-kernel@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net
Subject: Re: [PATCH 05/12] ieee1394 : Use mutex instead of semaphore in driver
 core
References: <20071229010939.GF2883@darkstar.te-china.tietoenator.com>
In-Reply-To: <20071229010939.GF2883@darkstar.te-china.tietoenator.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Young wrote:
> --- linux/drivers/ieee1394/nodemgr.c	2007-12-28 10:11:14.000000000 +0800
> +++ linux.new/drivers/ieee1394/nodemgr.c	2007-12-28 10:16:59.000000000 +0800
> @@ -18,8 +18,8 @@
>  #include <linux/moduleparam.h>
>  #include <linux/mutex.h>
>  #include <linux/freezer.h>
> +#include <linux/mutex.h>
>  #include <asm/atomic.h>
> -#include <asm/semaphore.h>

linux/mutex.h would be included twice.

ACK to the rest of this part of the series.
-- 
Stefan Richter
-=====-=-=== ==-- ===-=
http://arcgraph.de/sr/
