Return-Path: <linux-kernel-owner+w=401wt.eu-S1754569AbYDHNoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbYDHNoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 09:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbYDHNoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 09:44:13 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:56972 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810AbYDHNoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 09:44:12 -0400
Date: Tue, 8 Apr 2008 16:44:11 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@ozlabs.org>, Jeff Garzik <jeff@garzik.org>
Subject: compile failure in pata_sil680.c
Message-ID: <Pine.SOC.4.64.0804081640100.28938@math.ut.ee>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 0f436eff54f90419ac1b8accfb3e6e17c4b49a4e introduces the following 
compile failure on ppc (not powerpc), prep subarch. Seems that 
machine_is is only defined in the new powerpc arch.

drivers/ata/pata_sil680.c: In function 'sil680_init_chip':
drivers/ata/pata_sil680.c:274: error: implicit declaration of function 'machine_is'
drivers/ata/pata_sil680.c:274: error: 'cell' undeclared (first use in this function)
drivers/ata/pata_sil680.c:274: error: (Each undeclared identifier is reported only once
drivers/ata/pata_sil680.c:274: error: for each function it appears in.)
make[2]: *** [drivers/ata/pata_sil680.o] Error 1

-- 
Meelis Roos (mroos@linux.ee)
