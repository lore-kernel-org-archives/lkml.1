Return-Path: <linux-kernel-owner+w=401wt.eu-S2992581AbXDYKbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992581AbXDYKbv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 06:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992578AbXDYKbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 06:31:51 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34525 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992549AbXDYKbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 06:31:50 -0400
Date: Wed, 25 Apr 2007 11:35:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <htejun@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Berck E. Nash" <flyboy@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org
Subject: Re: 2.6.21-rc7-mm1 BUG at kernel/sched-clock.c:175
 init_sched_clock()
Message-ID: <20070425113522.593cbaa3@the-village.bc.nu>
In-Reply-To: <462F2C86.7030009@gmail.com>
References: <462E4C4D.9020806@gmail.com>
	<20070425011654.222a2b4b.akpm@linux-foundation.org>
	<462F1481.8010807@gmail.com>
	<20070425085432.GD17130@htj.dyndns.org>
	<20070425112533.19d4a1aa@the-village.bc.nu>
	<462F2C86.7030009@gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > (and yes this happens on dual P3 boxes - NE2K has some fantastic bugs at
> > one point due to this)
> 
> I think the second patch should work regardless of IRQ posting.  No?

I believe so providing the IRQ handler tries to clear the cause of the
IRQ.

Alan
