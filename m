Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbXL2N6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbXL2N6k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 08:58:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753542AbXL2N6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 08:58:32 -0500
Received: from h155.mvista.com ([63.81.120.155]:12046 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753457AbXL2N6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 08:58:31 -0500
Message-ID: <477652A3.2020900@ru.mvista.com>
Date: Sat, 29 Dec 2007 16:58:59 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] ide: add IDE_HFLAG_NO_DSC host flag
References: <200712271838.00351.bzolnier@gmail.com>
In-Reply-To: <200712271838.00351.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> * Add IDE_HFLAG_NO_DSC host flag for hosts that doesn't support DSC overlap.

> * Set it in aec62xx (for ATP850UF only) and hpt34x host drivers.

> * Convert ide-tape device driver to check for IDE_HFLAG_NO_DSC flag.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

> Index: b/include/linux/ide.h
> ===================================================================
> --- a/include/linux/ide.h
> +++ b/include/linux/ide.h
> @@ -1098,6 +1098,8 @@ enum {
>  	IDE_HFLAG_CY82C693		= (1 << 27),
>  	/* force host out of "simplex" mode */
>  	IDE_HFLAG_CLEAR_SIMPLEX		= (1 << 28),
> +	/* DSC overlap is unsupported */
> +	IDE_HFLAG_NO_DSC		= (1 << 29),
>  };

    Too many flags -- you'll run out of sizeof(unsigned) soon. :-)

MBR, Sergei
