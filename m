Return-Path: <linux-kernel-owner+w=401wt.eu-S1759973AbYBYAZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759973AbYBYAZE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 19:25:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbYBYAYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 19:24:54 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:51777 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbYBYAYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 19:24:53 -0500
Date: Mon, 25 Feb 2008 09:25:15 +0900 (JST)
Message-Id: <20080225.092515.126141645.anemo@mba.ocn.ne.jp>
To: nforrester@whoi.edu
Cc: david-b@pacbell.net, spi-devel-general@lists.sourceforge.net,
       marc.pignat@hevs.ch, linux-kernel@vger.kernel.org
Subject: Re: [spi-devel-general] [PATCH] atmel_spi: support zero length
 transfer
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <47BF2455.8030904@whoi.edu>
References: <47BED734.5030002@whoi.edu>
	<20080222190228.2B0CB28E363@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
	<47BF2455.8030904@whoi.edu>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2008 14:36:53 -0500, Ned Forrester <nforrester@whoi.edu> wrote:
> Or are you and Atsushi talking about using spi_transfer.delay_usecs
> *with* a zero length transfer to effectively put a delay between the
> assertion of CS and the start of the first clock?  If so, then I guess I
> missed the original point.  Sorry.

Yes.  I want to use zero length transfer with delay_usecs to achieve
CS-CLK delay for my funny device.  And I was too lazy to reject true
nop transfer.

---
Atsushi Nemoto
