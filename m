Return-Path: <linux-kernel-owner+w=401wt.eu-S932543AbXJPGtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543AbXJPGtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 02:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761445AbXJPGtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 02:49:12 -0400
Received: from asia.telenet-ops.be ([195.130.137.74]:41451 "EHLO
	asia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbXJPGtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 02:49:10 -0400
Date: Tue, 16 Oct 2007 08:49:02 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: James Bottomley <James.Bottomley@SteelEye.com>,
       Boaz Harrosh <bharrosh@panasas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [GIT PATCH] SCSI updates for 2.6.24
In-Reply-To: <1192421381.3429.6.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0710160846030.16889@anakin>
References: <1192421381.3429.6.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007, James Bottomley wrote:
> This is the accumulated updates queued for 2.6.24.  It contains the
> usual slew of driver updates, plus some gdth and advansys rewrites.  We
> still have some outstanding bugs in gdth and fc4 for which I'm hoping to
> sweep fixes into the next update.

> Boaz Harrosh (12):
>       NCR5380: Use scsi_eh API for REQUEST_SENSE invocation

This change broke compilation of the mac_scsi.c driver:

| linux/drivers/scsi/NCR5380.c: In function 'NCR5380_information_transfer':
| linux/drivers/scsi/NCR5380.c:2282: error: 'struct NCR5380_hostdata' has no member named 'ses'
| linux/drivers/scsi/NCR5380.c:2283: error: 'struct NCR5380_hostdata' has no member named 'ses'
| linux/drivers/scsi/NCR5380.c:2284: error: 'struct NCR5380_hostdata' has no member named 'ses'
| linux/drivers/scsi/NCR5380.c:2288: error: 'struct NCR5380_hostdata' has no member named 'ses'

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
