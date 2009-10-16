Return-Path: <linux-kernel-owner+w=401wt.eu-S932581AbZJPOsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581AbZJPOsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 10:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932368AbZJPOsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 10:48:09 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:42057 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759812AbZJPOsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 10:48:08 -0400
Message-ID: <4AD88729.3050209@s5r6.in-berlin.de>
Date: Fri, 16 Oct 2009 16:46:01 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.22) Gecko/20090605 SeaMonkey/1.1.17
MIME-Version: 1.0
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
CC: trivial@kernel.org, akpm@linux-foundation.org, adobriyan@gmail.com,
       linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 1/8] trivial: coding style fixes
References: <1255635840-5691-1-git-send-email-cascardo@holoscopio.com>
In-Reply-To: <1255635840-5691-1-git-send-email-cascardo@holoscopio.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thadeu Lima de Souza Cascardo wrote:
> --- a/drivers/mmc/card/sdio_uart.c
> +++ b/drivers/mmc/card/sdio_uart.c
[...]
> @@ -946,31 +948,31 @@ static int sdio_uart_proc_show(struct seq_file *m, void *v)
>  			seq_printf(m, "%d: uart:SDIO", i);
>  			if(capable(CAP_SYS_ADMIN)) {
>  				seq_printf(m, " tx:%d rx:%d",
> -					       port->icount.tx, port->icount.rx);
> +					      port->icount.tx, port->icount.rx);
>  				if (port->icount.frame)
>  					seq_printf(m, " fe:%d",
> -						       port->icount.frame);
> +						      port->icount.frame);
>  				if (port->icount.parity)
>  					seq_printf(m, " pe:%d",
> -						       port->icount.parity);
> +						      port->icount.parity);
>  				if (port->icount.brk)
>  					seq_printf(m, " brk:%d",
> -						       port->icount.brk);
> +						      port->icount.brk);
>  				if (port->icount.overrun)
>  					seq_printf(m, " oe:%d",
> -						       port->icount.overrun);
> +						      port->icount.overrun);
>  				if (port->icount.cts)
[...]

The style problem of the original code was not indentation, but depth of
indentation levels.  Why not factor this cascade out to a
show_icount_fields() function?

Plus, I hope Jiri enhanced your changelog a bit before he committed it.
(I only looked at this patch because I was wondering what subsystem it
changed --- the patch title doesn't say it.)
-- 
Stefan Richter
-=====-==--= =-=- =----
http://arcgraph.de/sr/
