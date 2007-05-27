Return-Path: <linux-kernel-owner+w=401wt.eu-S1757173AbXE0PnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173AbXE0PnS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 11:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754774AbXE0PnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 11:43:07 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53435 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754723AbXE0PnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 11:43:06 -0400
Date: Sun, 27 May 2007 16:47:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] SCSI/initio fixes, cleanups, PCI API support
Message-ID: <20070527164748.7bef041b@the-village.bc.nu>
In-Reply-To: <20070527145200.GA17017@havoc.gtf.org>
References: <20070527145200.GA17017@havoc.gtf.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 May 2007 10:52:00 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> 
> This patchset presents the path to PCI API support in the initio driver.
> 
> But the first patch really begs the question:  Has this driver really
> been broken since Oct 2003?  If so, let's just delete it.

Jeff. I (and Christoph) have already done a complete initio overhaul
including the PCI API and Hotplug and submitted it.

Has it been broken - no. The value was always NULL so it always worked on
x86-32. Its a sucky driver but its not defunct.
