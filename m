Return-Path: <linux-kernel-owner+w=401wt.eu-S1752925AbXCLU5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925AbXCLU5f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 16:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbXCLU5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 16:57:35 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:40780 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752917AbXCLU5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 16:57:34 -0400
Date: Mon, 12 Mar 2007 22:00:15 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>, len.brown@intel.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: libata-acpi: allow _GTF on SATA, but disable on PATA for now
Message-ID: <20070312220015.094b7759@lxorguk.ukuu.org.uk>
In-Reply-To: <20070312095528.3dd7a693.kristen.c.accardi@intel.com>
References: <200703100559.l2A5x6kP017578@hera.kernel.org>
	<45F296B9.7000005@garzik.org>
	<20070310164059.4ba68bcc@lxorguk.ukuu.org.uk>
	<20070312095528.3dd7a693.kristen.c.accardi@intel.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Meanwhile, to solve the problem for these people, and without introducing
> a lot of new code at this stage in the release, perhaps you can suggest 
> a more accurate way to detect PATA vs. SATA so we can fix the bug?  

I think the problem starts with the question. It supposes the BIOS knows
the answer to the question in the first place. It also supposes we
haven't reconfigured the port in some cases I believe.

My guess is the problem needs approaching from the other end. Ask the
question "What does the ACPI BIOS expect it to be ?". If I follow the
spec correctly we can answer that question by asking what methods (_SDD,
_GTF etc) it provides.

I don't think anything else is reliable.

Alan
