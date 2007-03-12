Return-Path: <linux-kernel-owner+w=401wt.eu-S1030703AbXCLQ6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030703AbXCLQ6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 12:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030679AbXCLQ6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 12:58:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:34277 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030673AbXCLQ6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 12:58:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,275,1170662400"; 
   d="scan'208"; a="208121501:sNHT47222273"
Date: Mon, 12 Mar 2007 09:55:28 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>, len.brown@intel.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: libata-acpi: allow _GTF on SATA, but disable on PATA for now
Message-Id: <20070312095528.3dd7a693.kristen.c.accardi@intel.com>
In-Reply-To: <20070310164059.4ba68bcc@lxorguk.ukuu.org.uk>
References: <200703100559.l2A5x6kP017578@hera.kernel.org>
	<45F296B9.7000005@garzik.org>
	<20070310164059.4ba68bcc@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Mar 2007 16:40:59 +0000
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> Instead merge the one that fixe the non PCI
> crashes and we might get further.

In bugzilla #7907 you could post your patch and see if the reporters there
can at least confirm that it fixes their problem.

Meanwhile, to solve the problem for these people, and without introducing
a lot of new code at this stage in the release, perhaps you can suggest 
a more accurate way to detect PATA vs. SATA so we can fix the bug?  Either 
that or Len should drop the ATA ACPI support from 2.6.21 altogether and
we should try to coordinate our efforts better for 2.6.22.  The alternative
to dropping the ACPI support is to set the default for libata.acpi to off.

Thanks,
Kristen
