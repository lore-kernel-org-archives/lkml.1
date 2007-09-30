Return-Path: <linux-kernel-owner+w=401wt.eu-S1758614AbXI3Pw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614AbXI3Pw1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 11:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757613AbXI3PwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 11:52:18 -0400
Received: from aa012msr.fastwebnet.it ([85.18.95.72]:36772 "EHLO
	aa012msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757473AbXI3PwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 11:52:17 -0400
Date: Sun, 30 Sep 2007 17:52:07 +0200
From: Paolo Ornati <ornati@fastwebnet.it>
To: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Tejun Heo <htejun@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH] blacklist NCQ on Seagate Barracuda ST380817AS
Message-ID: <20070930175207.5bfa89a8@localhost>
In-Reply-To: <46FFC42A.9080300@garzik.org>
References: <20070930160548.235be972@localhost>
	<20070930152908.1f58d39d@the-village.bc.nu>
	<20070930164610.20818867@localhost>
	<46FFBB2D.6060004@garzik.org>
	<20070930172859.7fd44eab@localhost>
	<46FFC42A.9080300@garzik.org>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.14; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Sep 2007 11:43:38 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> > it isn't supported here:
> > sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA  
> 
> Did you actually try my suggestion?

Yes ("libata.fua=1" is ok I think, or it should just be "libata.fua"?):
...
[    0.000000] Kernel command line: root=/dev/sda6 ro vga=0x305 libata.fua=1
...
[  285.004166] ata1.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x2 frozen
...


> 
> That message is normal, because libata defaults to FUA==off.

-- 
	Paolo Ornati
	Linux 2.6.23-rc8-ga64314e6 on x86_64
