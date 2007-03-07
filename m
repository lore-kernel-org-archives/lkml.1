Return-Path: <linux-kernel-owner+w=401wt.eu-S965506AbXCGOQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965506AbXCGOQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 09:16:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965515AbXCGOQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 09:16:27 -0500
Received: from www.osadl.org ([213.239.205.134]:46139 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965506AbXCGOQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 09:16:26 -0500
Subject: Re: Linux v2.6.21-rc3
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
In-Reply-To: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org>
Content-Type: text/plain
Date: Wed, 07 Mar 2007 15:22:34 +0100
Message-Id: <1173277354.24738.620.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-06 at 20:59 -0800, Linus Torvalds wrote:
> We've finally hopefully started to put a dent in the regressions, 
> especially the suspend/resume problems introduced since 2.6.20.

Still having SATA breakage on resume:

Caught that one (from screen)

ATA: abnormal status 0x7F on port 0x000118cf
irq 21: nobody cared (try booting ......)
...
Disabling IRQ #21


During normal boot I see the "ATA: abnormal status 0x7F on port
0x000118cf" once, but there the system behaves normal

	tglx


