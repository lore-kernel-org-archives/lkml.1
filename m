Return-Path: <linux-kernel-owner+w=401wt.eu-S1751554AbZL1ESM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbZL1ESM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 23:18:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbZL1ESH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 23:18:07 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:28470 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbZL1ESF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 23:18:05 -0500
Date: Sun, 27 Dec 2009 20:16:23 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Len Brown <lenb@kernel.org>
Cc: werner <w.landgraf@ru.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: kernel problem 2.6.33-rc2
Message-Id: <20091227201623.07e71915.randy.dunlap@oracle.com>
In-Reply-To: <alpine.LFD.2.00.0912252318090.4046@localhost.localdomain>
References: <web-122887026@zbackend1.aha.ru>
	<alpine.LFD.2.00.0912252318090.4046@localhost.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4B38314D.01A5:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Dec 2009 23:18:57 -0500 (EST) Len Brown wrote:

> > dell_wmi_init
> 
> Please try this patch.
> 
> From d11e073ee3e3091d9190dace97ce480e960cca1b Mon Sep 17 00:00:00 2001
> From: Len Brown <len.brown@intel.com>
> Date: Fri, 25 Dec 2009 23:14:26 -0500
> Subject: [PATCH] Revert "wmi: Free the allocated acpi objects through wmi_get_event_data"
> X-Patchwork-Hint: ignore
> 
> This reverts commit 3e9b988e4edf065d39c1343937f717319b1c1065.
> 
> Reported-by: Sedat Dilek <sedat.dilek@googlemail.com>
> Tested-by Maciej Rutecki <maciej.rutecki@gmail.com>
> Signed-off-by: Len Brown <len.brown@intel.com>
> ---
>  drivers/platform/x86/dell-wmi.c |    1 -
>  drivers/platform/x86/hp-wmi.c   |    2 --
>  drivers/platform/x86/wmi.c      |    4 ++--
>  3 files changed, 2 insertions(+), 5 deletions(-)

> diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
> index 9f93d6c..e425a86 100644
> --- a/drivers/platform/x86/wmi.c
> +++ b/drivers/platform/x86/wmi.c
> @@ -540,8 +540,8 @@ EXPORT_SYMBOL_GPL(wmi_remove_notify_handler);
>  /**
>   * wmi_get_event_data - Get WMI data associated with an event
>   *
> - * @event: Event to find
> - * @out: Buffer to hold event data. out->pointer should be freed with kfree()
> + * @event - Event to find
> + * &out - Buffer to hold event data

The '+' kernel-doc formatting is incorrect.
Needs to use ':'s and @out.


>   *
>   * Returns extra data associated with an event in WMI.
>   */


---
~Randy
