Return-Path: <linux-kernel-owner+w=401wt.eu-S1761287AbZEMUzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761287AbZEMUzW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 16:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757959AbZEMUzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 16:55:07 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3073 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbZEMUzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 16:55:06 -0400
Subject: Re: [PATCH 3/7] ide: merge ide_disk_special() into do_special()
From: Joe Perches <joe@perches.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090513205200.28638.90827.sendpatchset@localhost.localdomain>
References: <20090513205139.28638.87226.sendpatchset@localhost.localdomain>
	 <20090513205200.28638.90827.sendpatchset@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 13 May 2009 13:55:02 -0700
Message-Id: <1242248102.4639.17.camel@Joe-AcerAspire>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-13 at 22:52 +0200, Bartlomiej Zolnierkiewicz wrote:
> While at it:
> - change debug printk() level to KERN_DEBUG
> - update documentation
> 
> There should be no functional changes caused by this patch.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/ide/ide-io.c |   44 ++++++++++++++++++--------------------------
>  1 file changed, 18 insertions(+), 26 deletions(-)
> 
> Index: b/drivers/ide/ide-io.c
> ===================================================================
> --- a/drivers/ide/ide-io.c
> +++ b/drivers/ide/ide-io.c
> @@ -184,11 +184,28 @@ static void ide_tf_set_setmult_cmd(ide_d
[]
> +#ifdef DEBUG
> +	printk(KERN_DEBUG "%s: %s: 0x%02x\n", drive->name, s->all);
> +#endif

pr_debug?


