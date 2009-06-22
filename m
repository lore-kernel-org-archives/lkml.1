Return-Path: <linux-kernel-owner+w=401wt.eu-S1754764AbZFVGVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbZFVGVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 02:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753623AbZFVGVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 02:21:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34412
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753153AbZFVGVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 02:21:05 -0400
Date: Sun, 21 Jun 2009 23:21:09 -0700 (PDT)
Message-Id: <20090621.232109.26082365.davem@davemloft.net>
To: jaswinder@kernel.org
Cc: bzolnier@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IDE: ide-taskfile.c fix compilation warning and cleanup
From: David Miller <davem@davemloft.net>
In-Reply-To: <1245650973.30547.3.camel@ht.satnam>
References: <1245650973.30547.3.camel@ht.satnam>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jaswinder Singh Rajput <jaswinder@kernel.org>
Date: Mon, 22 Jun 2009 11:39:33 +0530

>  }
> @@ -227,7 +227,9 @@ void ide_pio_bytes(ide_drive_t *drive, struct ide_cmd *cmd,
>  	struct scatterlist *sg = hwif->sg_table;
>  	struct scatterlist *cursg = cmd->cursg;
>  	struct page *page;
> +#ifdef CONFIG_HIGHMEM
>  	unsigned long flags;
> +#endif

Please use __maybe_unused, which is designed for this kind of
situation.

Thank you.
