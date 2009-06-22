Return-Path: <linux-kernel-owner+w=401wt.eu-S1757252AbZFVO43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252AbZFVO43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 10:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756832AbZFVO4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 10:56:09 -0400
Received: from ares.ids.de ([88.79.252.171]:47042 "HELO ares.ids.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756964AbZFVO4H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 10:56:07 -0400
X-Greylist: delayed 1489 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Jun 2009 10:55:57 EDT
X-PGP-Universal: processed;
	by ares.ids.de on Mon, 22 Jun 2009 16:30:24 +0200
From: <Sergej.Stepanov@ids.de>
To: <chris.pringle@oxtel.com>, <scottwood@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Date: Mon, 22 Jun 2009 16:31:07 +0200
Subject: AW: PowerPC PCI DMA issues (prefetch/coherency?)
Thread-Topic: PowerPC PCI DMA issues (prefetch/coherency?)
Thread-Index: AcnwB8v0OR7NQk8dT4eVE0fA/grvlwDPPAh7
Message-ID: <4206182445660643B9AEB8D4E55BBD0A08533B67B5@HERMES2>
References: <4A37A503.3030209@oxtel.com>
	<20090616162114.GA5051@loki.buserror.net> <4A37C97A.5050508@oxtel.com>
	<4A37CC72.3060709@freescale.com> <4A37CF02.5080906@oxtel.com>
	<4A37D073.6020802@freescale.com> <4A38A21B.5060306@oxtel.com>
	<4A38ED31.9030705@oxtel.com>,<4A3A23FA.1000407@oxtel.com>
In-Reply-To: <4A3A23FA.1000407@oxtel.com>
Accept-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE
MIME-Version: 1.0
Content-Language: de-DE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>The other part of the fix is in asm-powerpc/pgtable32.h. _PAGE_BASE
>needs _PAGE_COHERENT in order to work correctly, and in fact there is
>now a comment in there to that affect in 2.6.29. Backporting that change
>has made it work on 2.6.26. Both this patch, and the fix to head_32.S
>are needed for it to work correctly on older kernels.
>
>Chris

Hello Chris,

sorry for dummy, but if it possible, could you, please, send a corresponding summary patch of backporting you've done for older kernels?
or just summary of that changes once again?

Many thanks

Sergej.