Return-Path: <linux-kernel-owner+w=401wt.eu-S1757146AbYGXMLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146AbYGXMLV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 08:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbYGXMLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 08:11:10 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:48013 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485AbYGXMLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 08:11:09 -0400
Date: Thu, 24 Jul 2008 14:10:03 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Huang Weiyi <weiyi.huang@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel@avr32linux.org
Subject: Re: drivers/misc/atmel-ssc.c: Removed duplicated include
Message-ID: <20080724141003.6f3b9c3b@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20080621223028.C979.WEIYI.HUANG@gmail.com>
References: <20080621223028.C979.WEIYI.HUANG@gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 24 Jul 2008 12:10:46.0236 (UTC) FILETIME=[4D8A29C0:01C8ED86]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Weiyi <weiyi.huang@gmail.com> wrote:
> Removed duplicated include file <linux/list.h> in 
> drivers/misc/atmel-ssc.c.
> 
> Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

Applied to the avr32 tree. Thanks, and sorry about the delay.

Haavard

> diff --git a/drivers/misc/atmel-ssc.c b/drivers/misc/atmel-ssc.c
> index e171650..bf5e4d0 100644
> --- a/drivers/misc/atmel-ssc.c
> +++ b/drivers/misc/atmel-ssc.c
> @@ -13,7 +13,6 @@
>  #include <linux/clk.h>
>  #include <linux/err.h>
>  #include <linux/io.h>
> -#include <linux/list.h>
>  #include <linux/spinlock.h>
>  #include <linux/atmel-ssc.h>
> 
