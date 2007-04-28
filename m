Return-Path: <linux-kernel-owner+w=401wt.eu-S1756408AbXD1Q0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408AbXD1Q0E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 12:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756406AbXD1Q0C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 12:26:02 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55137 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756400AbXD1Q0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 12:26:00 -0400
Date: Sat, 28 Apr 2007 17:29:39 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: "Shan, Guo Wen (Gavin)" <gshan@alcatel-lucent.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: can a kmalloc be both GFP_ATOMIC and GFP_KERNEL at the same
 time?
Message-ID: <20070428172939.35689110@the-village.bc.nu>
In-Reply-To: <Pine.LNX.4.64.0704281006380.25313@localhost.localdomain>
References: <2AC135F730C4A045BAE4F1C1CB83FD4B03EF6F87@exch03.qd.lucent.com>
	<Pine.LNX.4.64.0704281006380.25313@localhost.localdomain>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > drivers/scsi/aic7xxx_old.c:  aic_dev = kmalloc(sizeof(struct aic_dev_data), GFP_ATOMIC | GFP_KERNEL);
> > drivers/message/i2o/device.c:   resblk = kmalloc(buflen + 8, GFP_KERNEL | GFP_ATOMIC);
> >
> >   clarification?
> 
> oh, i'm *aware* of the definitions of those flags, but every single
> source i've ever read has *strongly* suggested that you don't use

I don't believe either of those is doing what the author intended 8).

Alan
