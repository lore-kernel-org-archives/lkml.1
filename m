Return-Path: <linux-kernel-owner+w=401wt.eu-S1756420AbYAGUTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420AbYAGUTA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 15:19:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbYAGUSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 15:18:51 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:42663 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbYAGUSv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 15:18:51 -0500
X-Greylist: delayed 620 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jan 2008 15:18:51 EST
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: Joe Perches <joe@perches.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       ISS StorageDev <iss_storagedev@hp.com>
Date: Mon, 7 Jan 2008 20:07:52 +0000
Subject: RE: [PATCH] drivers/block/: Spelling fixes
Thread-Topic: [PATCH] drivers/block/: Spelling fixes
Thread-Index: AchA44KiGyWEX0apStWsP1srotLKkgQhWioA
Message-ID: <DEE40752C8AF224BB890E455C7B8E0FE192EA777@G6W0268.americas.hpqcorp.net>
References: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918890.git.joe@perches.com>
In-Reply-To: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918890.git.joe@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: Monday, December 17, 2007 1:30 PM
> To: linux-kernel@vger.kernel.org
> Cc: Andrew Morton; Miller, Mike (OS Dev); ISS StorageDev
> Subject: [PATCH] drivers/block/: Spelling fixes
>
>
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Mike Miller <mike.miller@hp.com>

> ---
>  drivers/block/cciss_scsi.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/block/cciss_scsi.c
> b/drivers/block/cciss_scsi.c index 63ee6c0..55178e9 100644
> --- a/drivers/block/cciss_scsi.c
> +++ b/drivers/block/cciss_scsi.c
> @@ -1453,7 +1453,7 @@ static int
> cciss_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
>         rc = sendcmd(CCISS_RESET_MSG, ctlr, NULL, 0, 2, 0, 0,
>                 (unsigned char *)
> &cmd_in_trouble->Header.LUN.LunAddrBytes[0],
>                 TYPE_MSG);
> -       /* sendcmd turned off interrputs on the board, turn
> 'em back on. */
> +       /* sendcmd turned off interrupts on the board, turn
> 'em back on.
> + */
>         (*c)->access.set_intr_mask(*c, CCISS_INTR_ON);
>         if (rc == 0)
>                 return SUCCESS;
> @@ -1483,7 +1483,7 @@ static int
> cciss_eh_abort_handler(struct scsi_cmnd *scsicmd)
>                 0, 2, 0, 0,
>                 (unsigned char *)
> &cmd_to_abort->Header.LUN.LunAddrBytes[0],
>                 TYPE_MSG);
> -       /* sendcmd turned off interrputs on the board, turn
> 'em back on. */
> +       /* sendcmd turned off interrupts on the board, turn
> 'em back on.
> + */
>         (*c)->access.set_intr_mask(*c, CCISS_INTR_ON);
>         if (rc == 0)
>                 return SUCCESS;
> --
> 1.5.3.7.949.g2221a6
>
>
