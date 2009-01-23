Return-Path: <linux-kernel-owner+w=401wt.eu-S1764612AbZAWBdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764612AbZAWBdk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 20:33:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761798AbZAWBXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 20:23:39 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:27543 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762689AbZAWBXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 20:23:38 -0500
Message-ID: <49791C06.6010805@oracle.com>
Date: Thu, 22 Jan 2009 17:23:18 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Matt LaPlante <kernel1@cyberdogtech.com>
CC: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH 2/2] Kconfig cleanup - new.
References: <1232569236-11926-1-git-send-email-kernel1@cyberdogtech.com>
In-Reply-To: <1232569236-11926-1-git-send-email-kernel1@cyberdogtech.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.49791C09.01BF:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt LaPlante wrote:
> These are new kconfig cleanups, as of 2.6.29-rc2.

I only reviewed the new patch since you said that the other one had
already been approved.

> Not yet reviewed.
> 
> Signed-off-by: Matt LaPlante <kernel1@cyberdogtech.com>
> ---
>  arch/avr32/Kconfig                  |    6 +++---
>  drivers/hid/Kconfig                 |    2 +-
>  drivers/isdn/mISDN/Kconfig          |   10 ++++++----
>  drivers/media/common/tuners/Kconfig |    2 +-
>  drivers/mfd/Kconfig                 |    2 +-
>  drivers/mmc/host/Kconfig            |    2 +-
>  drivers/scsi/Kconfig                |    4 ++--
>  drivers/staging/Kconfig             |    4 ++--
>  drivers/staging/comedi/Kconfig      |    4 ++--
>  drivers/staging/go7007/Kconfig      |    4 ++--
>  drivers/staging/panel/Kconfig       |    2 +-
>  drivers/usb/gadget/Kconfig          |    2 +-
>  drivers/uwb/Kconfig                 |    4 ++--
>  drivers/xen/Kconfig                 |    2 +-
>  fs/Kconfig                          |    2 +-
>  fs/ext4/Kconfig                     |    2 +-
>  fs/ubifs/Kconfig                    |    4 ++--
>  init/Kconfig                        |    2 +-
>  kernel/trace/Kconfig                |    9 ++++-----
>  net/phonet/Kconfig                  |    2 +-
>  net/wimax/Kconfig                   |    2 +-
>  sound/soc/blackfin/Kconfig          |    2 +-
>  22 files changed, 38 insertions(+), 37 deletions(-)


> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index e2a4ff6..d85ab89 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -71,11 +71,10 @@ config FUNCTION_GRAPH_TRACER
>  	help
>  	  Enable the kernel to trace a function at both its return
>  	  and its entry.
> -	  It's first purpose is to trace the duration of functions and
> -	  draw a call graph for each thread with some informations like
> -	  the return value.
> -	  This is done by setting the current return address on the current
> -	  task structure into a stack of calls.
> +	  Its first purpose is to trace the duration of functions and
> +	  draw a call graph for each thread with some information like
> +	  the return value. This is done by setting the current return 
> +    address on the current task structure into a stack of calls.

spacing typo.
Fix that & add:
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

>  
>  config IRQSOFF_TRACER
>  	bool "Interrupts-off Latency Tracer"


Thanks,
-- 
~Randy
