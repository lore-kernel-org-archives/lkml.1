Return-Path: <linux-kernel-owner+w=401wt.eu-S1765450AbXGaQI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765450AbXGaQI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 12:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759670AbXGaQH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 12:07:57 -0400
Received: from fizeau.zen.co.uk ([212.23.8.67]:58297 "EHLO fizeau.zen.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759451AbXGaQH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 12:07:56 -0400
From: David Vrabel <david.vrabel@csr.com>
To: linux-kernel@vger.kernel.org
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Subject: sdio: enhance IO_RW_EXTENDED support
Date: Tue, 31 Jul 2007 16:36:30 +0100
Message-Id: <11858961933491-git-send-email-david.vrabel@csr.com>
X-Mailer: git-send-email 1.4.4.4
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: david@pear.davidvrabel.org.uk
X-SA-Exim-Scanned: No (on pear.davidvrabel.org.uk); SAEximRunCond expanded to false
X-Originating-Pythagoras-IP: [82.70.146.41]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These three patches enhance the support for the SDIO IO_RW_EXTENDED command.
The block size of functions is managed and the I/O ops (sdio_readsb() etc) are
extended to handle arbitrary lengths of data (by using multiple commands).

I've not yet had a chance to test this stuff as I don't (yet) have the time to
write a Bluetooth Type-A driver so these are posted as an example of the sort
of API I'd expect.

David
-- 
David Vrabel, Software Engineer, Drivers group Tel: +44 (0)1223 692562
CSR plc, Churchill House, Cambridge Business Park, Cowley Road, CB4 0WZ 
