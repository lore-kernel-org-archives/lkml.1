Return-Path: <linux-kernel-owner+w=401wt.eu-S1760701AbYGQTJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760701AbYGQTJZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 15:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757932AbYGQTJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 15:09:17 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:56449 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757901AbYGQTJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 15:09:16 -0400
Message-ID: <487F98D9.1@garzik.org>
Date: Thu, 17 Jul 2008 15:09:13 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: ata error message exception Emask 0x0 SAct 0x0 SErr 0x0 action
 0x2
References: <20080716212605.GA8244@digitasaru.net>
In-Reply-To: <20080716212605.GA8244@digitasaru.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joseph Pingenot wrote:
> Hi all.
> 
> Anyone know what is causing the following troubles:
> Jul 16 16:16:27 cruftix kernel: [12538.998440] ata5.00: exception Emask
> 0x0 SAct 0x0 SErr 0x0 action 0x2
> Jul 16 16:16:27 cruftix kernel: [12538.998450] ata5.00: irq_stat
> 0x00020002, device error via D2H FIS
> Jul 16 16:16:27 cruftix kernel: [12538.998457] ata5.00: cmd
> 35/00:08:87:17:58/00:00:59:00:00/e0 tag 0 dma 4096 out
> Jul 16 16:16:27 cruftix kernel: [12538.998459]          res
> 51/84:00:8e:17:58/00:00:59:00:00/e0 Emask 0x10 (ATA bus error)
> Jul 16 16:16:27 cruftix kernel: [12538.998464] ata5.00: status: { DRDY
> ERR }
> Jul 16 16:16:27 cruftix kernel: [12538.998466] ata5.00: error: { ICRC
> ABRT }

See http://ata.wiki.kernel.org/index.php/Libata_error_messages

An ATA bus error means there is a problem on the ATA bus -- either a 
cable, cable interference, stuff like that.

	Jeff



