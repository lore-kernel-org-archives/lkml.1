Return-Path: <linux-kernel-owner+w=401wt.eu-S1756020Ab0ARTKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab0ARTKv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 14:10:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755961Ab0ARTKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 14:10:50 -0500
Received: from gateway-1237.mvista.com ([206.112.117.35]:38146 "HELO
	imap.sh.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1754185Ab0ARTKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 14:10:50 -0500
Message-ID: <4B54B1CE.7030901@ru.mvista.com>
Date: Mon, 18 Jan 2010 22:09:02 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 24/64] ide: fix for ide_timing quantisation errors
References: <20100118171349.14623.90030.sendpatchset@localhost> <20100118171720.14623.86072.sendpatchset@localhost>
In-Reply-To: <20100118171720.14623.86072.sendpatchset@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] ide: fix for ide_timing quantisation errors
>
> Based on commit 4f701d1 for libata.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/ide/ide-timings.c |    6 ++++++
>  1 file changed, 6 insertions(+)
>
> Index: b/drivers/ide/ide-timings.c
> ===================================================================
> --- a/drivers/ide/ide-timings.c
> +++ b/drivers/ide/ide-timings.c
> @@ -206,6 +206,12 @@ int ide_timing_compute(ide_drive_t *driv
>  		t->recover = t->cycle - t->active;
>  	}
>  
> +	/* In a few cases quantisation may produce enough errors to
> +	   leave t->cycle too low for the sum of active and recovery
> +	   if so we must correct this */
>   

   Comment style should preferrably be:

/*
 * blah
 * blah
 * blah
 */

MBR, Sergei

