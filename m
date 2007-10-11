Return-Path: <linux-kernel-owner+w=401wt.eu-S1756649AbXJKOqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649AbXJKOqG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 10:46:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbXJKOpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 10:45:55 -0400
Received: from [81.2.110.250] ([81.2.110.250]:54283 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751748AbXJKOpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 10:45:54 -0400
Date: Thu, 11 Oct 2007 15:50:24 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Bernd Schubert <bs@q-leap.de>, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] faster workaround
Message-ID: <20071011155024.46007973@the-village.bc.nu>
In-Reply-To: <470E30F9.5060705@garzik.org>
References: <200710081709.18253.bs@q-leap.de>
	<200710101112.20448.bs@q-leap.de>
	<200710111409.56210.bs@q-leap.de>
	<200710111433.23833.bs@q-leap.de>
	<20071011142628.48272a4a@the-village.bc.nu>
	<470E30F9.5060705@garzik.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The problem is that the 3112 generates Data FIS's of a size other than a 
> multiple of 512 bytes.  Spec-legal, but exposed firmware bugs in many 
> early SATA drives.  Early Seagate hard drives choked when the formula 
> (sector%15)==1 was satisfied (or something along those lines).

And the 3114 is the same ?

> 2) Once we identified, over time, the set of drives affected by this 
> 3112 quirk (aka drives that didn't fully comply to SATA spec), the 
> debugging of corruption cases largely shifted to the standard routine: 
> update the BIOS, replace the cables/RAM/power/mainboard/slot/etc. to be 
> certain of problem location.

Except for the continued series of later SI + Nvidia chipset (mostly)
pattern which seems unanswered but also being later chips I assume
unrelated to this problem.
