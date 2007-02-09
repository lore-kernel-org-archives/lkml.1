Return-Path: <linux-kernel-owner+w=401wt.eu-S1423246AbXBIUC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423246AbXBIUC7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 15:02:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423284AbXBIUC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 15:02:59 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41690 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423246AbXBIUC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 15:02:58 -0500
Date: Fri, 9 Feb 2007 20:16:08 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Luigi Genoni <genoni@sns.it>
Subject: Re: [BUG?] ata disk running maximum at DMA33 with 2.6.20 and new
 pata driver, NV CK804 ide controller.
Message-ID: <20070209201608.0c1695db@localhost.localdomain>
In-Reply-To: <45CAA8EA.2010505@shaw.ca>
References: <fa.xQT7YaGQERXkjuW4tC35jsdiTD0@ifi.uio.no>
	<fa.Bv1nbk8Z669RxoYF6zPFpsCsyd4@ifi.uio.no>
	<45CAA8EA.2010505@shaw.ca>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> As an aside to this sort of problem, shouldn't we print some kind of 
> loud message in dmesg when we force a high-UDMA-capable device down to 
> UDMA33 due to a 40-wire cable detection? In the case where it truly is a 
> 40-wire cable the user may want to know that and replace the cable, if 
> it isn't it gives more of a hint of why the drive isn't running at full 
> speed..

Send patches. We also probably want to change speed straight from
UDMAlots to UDMA33 if the cable is CBL_UNK so that we can rapidly recover
in the cases where the controller says "I'm crap I don't really know" (eg
ATI and Nvidia without ACPI)
