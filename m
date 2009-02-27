Return-Path: <linux-kernel-owner+w=401wt.eu-S1758894AbZB0A7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894AbZB0A7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 19:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbZB0A7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 19:59:04 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:53573 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731AbZB0A7B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 19:59:01 -0500
MIME-Version: 1.0
In-Reply-To: <20090222000150.17557.8753.stgit@vmbox.hanneseder.net>
References: <20090221235706.17557.97714.stgit@vmbox.hanneseder.net>
	 <20090222000150.17557.8753.stgit@vmbox.hanneseder.net>
Date: Fri, 27 Feb 2009 01:58:57 +0100
Message-ID: <154e089b0902261658t14c1339dj55e7f4ff4aede372@mail.gmail.com>
Subject: Re: [PATCH 04/16] ide: fix sparse warnings: Using plain integer as 
	NULL pointer
From: Hannes Eder <hannes@hanneseder.net>
To: trivial@kernel.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added To]

On Sun, Feb 22, 2009 at 1:01 AM, Hannes Eder <hannes@hanneseder.net> wrote:
> Fix this sparse warnings:
>  drivers/ide/ide-disk_proc.c:130:11: warning: Using plain integer as NULL pointer
>  drivers/ide/ide-floppy_proc.c:32:11: warning: Using plain integer as NULL pointer
>  drivers/ide/ide-proc.c:234:11: warning: Using plain integer as NULL pointer
>  drivers/ide/ide-tape.c:2141:11: warning: Using plain integer as NULL pointer
>
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> ---
>  drivers/ide/ide-disk_proc.c   |    2 +-
>  drivers/ide/ide-floppy_proc.c |    2 +-
>  drivers/ide/ide-proc.c        |    2 +-
>  drivers/ide/ide-tape.c        |    2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/ide/ide-disk_proc.c b/drivers/ide/ide-disk_proc.c
> index 3f2a078..eaea3be 100644
> --- a/drivers/ide/ide-disk_proc.c
> +++ b/drivers/ide/ide-disk_proc.c
> @@ -127,5 +127,5 @@ const struct ide_proc_devset ide_disk_settings[] = {
>        IDE_PROC_DEVSET(multcount,      0,    16),
>        IDE_PROC_DEVSET(nowerr,         0,     1),
>        IDE_PROC_DEVSET(wcache,         0,     1),
> -       { 0 },
> +       { NULL },
>  };
> diff --git a/drivers/ide/ide-floppy_proc.c b/drivers/ide/ide-floppy_proc.c
> index 3ec762c..fcd4d81 100644
> --- a/drivers/ide/ide-floppy_proc.c
> +++ b/drivers/ide/ide-floppy_proc.c
> @@ -29,5 +29,5 @@ const struct ide_proc_devset ide_floppy_settings[] = {
>        IDE_PROC_DEVSET(bios_head, 0,  255),
>        IDE_PROC_DEVSET(bios_sect, 0,   63),
>        IDE_PROC_DEVSET(ticks,     0,  255),
> -       { 0 },
> +       { NULL },
>  };
> diff --git a/drivers/ide/ide-proc.c b/drivers/ide/ide-proc.c
> index 0ee8887..10a88bf 100644
> --- a/drivers/ide/ide-proc.c
> +++ b/drivers/ide/ide-proc.c
> @@ -231,7 +231,7 @@ static const struct ide_proc_devset ide_generic_settings[] = {
>        IDE_PROC_DEVSET(pio_mode, 0, 255),
>        IDE_PROC_DEVSET(unmaskirq, 0, 1),
>        IDE_PROC_DEVSET(using_dma, 0, 1),
> -       { 0 },
> +       { NULL },
>  };
>
>  static void proc_ide_settings_warn(void)
> diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
> index 1b97d7a..e9e570f 100644
> --- a/drivers/ide/ide-tape.c
> +++ b/drivers/ide/ide-tape.c
> @@ -2138,7 +2138,7 @@ static const struct ide_proc_devset idetape_settings[] = {
>        __IDE_PROC_DEVSET(speed,        0, 0xffff, NULL, NULL),
>        __IDE_PROC_DEVSET(tdsc,         IDETAPE_DSC_RW_MIN, IDETAPE_DSC_RW_MAX,
>                                        mulf_tdsc, divf_tdsc),
> -       { 0 },
> +       { NULL },
>  };
>  #endif
>
>
>
