Return-Path: <linux-kernel-owner+w=401wt.eu-S965538AbXCLLHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965538AbXCLLHt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 07:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965540AbXCLLHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 07:07:49 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52298 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965538AbXCLLHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 07:07:48 -0400
Date: Mon, 12 Mar 2007 12:10:32 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <htejun@gmail.com>
Cc: Fabio Comolli <fabio.comolli@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH] libata: don't whine if ->prereset() returns -ENOENT
Message-ID: <20070312121032.3cfd1786@lxorguk.ukuu.org.uk>
In-Reply-To: <45F50E28.7010509@gmail.com>
References: <20070309163148.GA12848@havoc.gtf.org>
	<b637ec0b0703091324q7f15fddbpc8c24b4e1131e3f4@mail.gmail.com>
	<20070309234839.2070a265@lxorguk.ukuu.org.uk>
	<45F50E28.7010509@gmail.com>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 1. I think these ports should be made dummy instead of returning
> -ENOENT on prereset().  -ENOENT from prereset() was a hack to keep
> ata_piix's behavior unchanged while converting it to new EH.  If no
> one objcts, I'll convert similar usages to use dummy ports after new
> init model and drop -ENOENT hack in #upstream.

No objection at all.

> 2. -ENODEV sounds more appropriate.  Why have I used -ENOENT.  :-)

You didn't - I did. I think -ENOENT is better as we are missing an entire
channel not a device (disk).

>
