Return-Path: <linux-kernel-owner+w=401wt.eu-S934093AbXEWN6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934093AbXEWN6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 09:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757101AbXEWN6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 09:58:05 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60832 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756706AbXEWN6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 09:58:02 -0400
Date: Wed, 23 May 2007 15:02:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>, Robert de Rooy <robert.de.rooy@gmail.com>,
       linux-kernel@vger.kernel.org, bzolnier@gmail.com,
       linux-pcmcia@lists.infradead.org
Subject: Re: libata and legacy ide pcmcia failure
Message-ID: <20070523150229.00a0c3c4@the-village.bc.nu>
In-Reply-To: <46520B36.90409@garzik.org>
References: <464A0321.3080201@gmail.com>
	<464C1575.8070005@gmail.com>
	<464CB7C9.2080807@gmail.com>
	<46503192.1040300@gmail.com>
	<4650B9E3.7070409@gmail.com>
	<46518798.2020808@gmail.com>
	<4651B66E.6030505@gmail.com>
	<4651B834.3060702@gmail.com>
	<4651C4A1.6000101@gmail.com>
	<4651C74B.7020108@gmail.com>
	<46520B36.90409@garzik.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >   http://thread.gmane.org/gmane.linux.kernel/530099
> > 
> > It seems we're losing interrupts from the CFA device.  Any ideas?
> 
> Alan probably knows more, but ISTR some CFA PCMCIA devices that needed 
> polling...

Not that I know of. Not devices anyway - there are embedded boxes with no
IRQ configuration for the CF slot but we've never supported those (indeed
there are even people who bitbang ATA on GPIO pins...)
