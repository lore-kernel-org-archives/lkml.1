Return-Path: <linux-kernel-owner+w=401wt.eu-S1756958AbYBKPbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958AbYBKPbb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 10:31:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754600AbYBKPbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 10:31:09 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:52438 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754464AbYBKPbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 10:31:07 -0500
Message-ID: <47B06A36.5030201@pobox.com>
Date: Mon, 11 Feb 2008 10:31:02 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Adrian McMenamin <lkmladrian@gmail.com>
CC: Paul Mundt <lethal@linux-sh.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-sh <linux-sh@vger.kernel.org>
Subject: Re: [PATCH] 8139too fix for Dreamcast
References: <8b67d60802080321o6f6c8ca7x768d911a6f1fba0b@mail.gmail.com>
In-Reply-To: <8b67d60802080321o6f6c8ca7x768d911a6f1fba0b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian McMenamin wrote:
> Updates the 8139too driver to work with recently added
> (a724605cb7a66d423a494a395f9a8ba871b8a1eb) declared coherent memory
> patch for the Dreamcast.
> 
> Jeff - I am assuming you are still the maintainer and I guess Paul
> should also ack this as it is SH related.
> 
> Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
> 
> -----
> 
> 
> diff --git a/drivers/net/8139too.c b/drivers/net/8139too.c
> index d373545..80f1cce 100644
> --- a/drivers/net/8139too.c
> +++ b/drivers/net/8139too.c
> @@ -168,7 +168,7 @@ static int debug = -1;
>   * Warning: 64K ring has hardware issues and may lock up.
>   */
>  #if defined(CONFIG_SH_DREAMCAST)
> -#define RX_BUF_IDX	1	/* 16K ring */
> +#define RX_BUF_IDX 0	/* 8K ring */
>  #else
>  #define RX_BUF_IDX	2	/* 32K ring */
>  #endif

applied...  yell if that's a problem Paul



