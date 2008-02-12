Return-Path: <linux-kernel-owner+w=401wt.eu-S1755845AbYBLV5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845AbYBLV5r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 16:57:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbYBLV5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 16:57:35 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60532 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755536AbYBLV5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 16:57:34 -0500
Date: Tue, 12 Feb 2008 21:50:06 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bart Dopheide <dopheide@fmf.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel BUG at fs/mpage.c:489
Message-ID: <20080212215006.170ade88@core>
In-Reply-To: <20080212194546.GA2174@fmf.nl>
References: <20080212194546.GA2174@fmf.nl>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Feb 12 19:55:08 butterfly kernel: hde: dma timeout error: status=0xd0 { Busy }
> Feb 12 19:55:08 butterfly kernel: ide: failed opcode was: unknown

Your drive stopped responding.

> Feb 12 19:55:08 butterfly kernel: hde: DMA disabled
> Feb 12 19:55:08 butterfly kernel: PDC202XX: Primary channel reset.
> Feb 12 19:55:08 butterfly kernel: PDC202XX: Secondary channel reset.

We gave it a good kicking and it stayed offline

> Feb 12 19:55:08 butterfly kernel: hde: set_drive_speed_status: status=0xd0 { Busy }
> Feb 12 19:55:08 butterfly kernel: ide: failed opcode was: unknown
> Feb 12 19:55:47 butterfly kernel: ide2: reset timed-out, status=0xd0
> Feb 12 19:55:47 butterfly kernel: hde: status timeout: status=0xd0 { Busy }

And we gave up.

Almost certainly a hardware fail of some sort.
