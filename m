Return-Path: <linux-kernel-owner+w=401wt.eu-S1161443AbXDVQTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161443AbXDVQTS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 12:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161395AbXDVQTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 12:19:17 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52967 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161371AbXDVQTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 12:19:16 -0400
Date: Sun, 22 Apr 2007 17:22:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: rene@exactcode.de, todorovic.s@googlemail.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: InitIO SCSI: Volunteers required
Message-ID: <20070422172247.0f284e30@the-village.bc.nu>
In-Reply-To: <20070422141423.GA8928@infradead.org>
References: <20070420103849.7358f1f1@the-village.bc.nu>
	<20070422141423.GA8928@infradead.org>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This doesn't change much outside the initialization and irq code, so
> any additional de-crappyfication will hopefully apply ontop.

This will actually clash horribly with the rest of the rework, so it does
need to be applied after the other changes. The driver in my tree no
longer looks much like the driver you are hacking on because its been
turned into a Linux driver.

Its just a matter of ordering of the changes to get this merged nicely.

Don't suppose you also did the other scsi offenders ?

Alan
