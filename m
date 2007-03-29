Return-Path: <linux-kernel-owner+w=401wt.eu-S1030667AbXC2U3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030667AbXC2U3X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 16:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030678AbXC2U3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 16:29:23 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35938 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030667AbXC2U3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 16:29:22 -0400
Date: Thu, 29 Mar 2007 22:33:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Lee Revell" <rlrevell@joe-job.com>
Cc: "Kevin Perros" <kevin.perros@free.fr>, John <linux.kernel@free.fr>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.20.3-rt8 - DMA suffers excessive delay periodically
Message-ID: <20070329223309.26f43c73@the-village.bc.nu>
In-Reply-To: <75b66ecd0703291231n1b7cbcfcpbb16f4cfee933c2c@mail.gmail.com>
References: <46094728.40300@free.fr>
	<75b66ecd0703271341x34463c49w64bdac21a9741355@mail.gmail.com>
	<460A297A.2030200@free.fr>
	<460C094C.8070304@free.fr>
	<75b66ecd0703291231n1b7cbcfcpbb16f4cfee933c2c@mail.gmail.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The problem could also be something other than SMM, like DMA
> starvation by a video or disk controller.  Try disabling all hard
> drive controllers and booting from a CD or USB stick.

You'll get starvation from the disk DMA but only if you are using the
disk and doing DMA otherwise it won't have much effect. If you drop the
older VIA's down to about UDMA33 or UDMA66 they normally behave
themselves. This is a problem folks see with the older boards and video
capture particularly
