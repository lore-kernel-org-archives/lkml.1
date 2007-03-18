Return-Path: <linux-kernel-owner+w=401wt.eu-S932850AbXCRStS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932850AbXCRStS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 14:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932878AbXCRStQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 14:49:16 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:34321 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932771AbXCRStO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 14:49:14 -0400
Date: Sun, 18 Mar 2007 19:49:15 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz, Vladimir Brik <no.hope@gmail.com>,
       Andi Kleen <ak@muc.de>, Ray Lee <ray-lk@madrabbit.org>, lenb@kernel.org,
       linux-acpi@vger.kernel.org, Colchao <colchaodemola@gmail.com>,
       Mathieu =?utf-8?Q?B=C3=A9rard?= <Mathieu.Berard@crans.org>,
       Tejun Heo <htejun@gmail.com>, jgarzik@pobox.com,
       linux-ide@vger.kernel.org,
       Michal Jaegermann <michal@ellpspace.math.ualberta.ca>,
       Fabio Comolli <fabio.comolli@gmail.com>,
       Plamen Petrov <plamen.petrov@tk.ru.acad.bg>,
       Laurent Riffard <laurent.riffard@free.fr>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [2/6] 2.6.21-rc4: known regressions
Message-ID: <20070318184915.GV752@stusta.de>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This email lists some known regressions in Linus' tree compared to 2.6.20.

If you find your name in the Cc header, you are either submitter of one
of the bugs, maintainer of an affectected subsystem or driver, a patch
of you caused a breakage or I'm considering you in any other way
possibly involved with one or more of these issues.

Due to the huge amount of recipients, please trim the Cc when answering.


Subject    : x86_64: boot hangs unless CONFIG_PCIEPORTBUS=n and acpi=off
References : http://bugzilla.kernel.org/show_bug.cgi?id=8162
Submitter  : Randy Dunlap <randy.dunlap@oracle.com>
Status     : unknown


Subject    : AMD Elan: Crash after "Allocating PCI resources"
References : http://bugzilla.kernel.org/show_bug.cgi?id=8161
Submitter  : Vladimir Brik <no.hope@gmail.com>
Handled-By : Andi Kleen <ak@muc.de>
Status     : patch available


Subject    : ACPI regression with noapic
References : http://lkml.org/lkml/2007/3/8/468
Submitter  : Ray Lee <ray-lk@madrabbit.org>
Status     : unknown


Subject    : acpi_serialize locks system during boot
References : http://bugzilla.kernel.org/show_bug.cgi?id=8171
Submitter  : Colchao <colchaodemola@gmail.com>
Handled-By : Len Brown <len.brown@intel.com>
Patch      : http://bugzilla.kernel.org/show_bug.cgi?id=8171
Status     : patch available


Subject    : NCQ problem with ahci and Hitachi drive  (ACPI related)
References : http://lkml.org/lkml/2007/3/4/178
             http://lkml.org/lkml/2007/3/9/475
Submitter  : Mathieu Bérard <Mathieu.Berard@crans.org>
Handled-By : Tejun Heo <htejun@gmail.com>
Status     : problem is being debugged


Subject    : kernels fail to boot with drives on ATIIXP controller
             (ACPI/IRQ related)
References : https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=229621
             http://lkml.org/lkml/2007/3/4/257
Submitter  : Michal Jaegermann <michal@ellpspace.math.ualberta.ca>
Status     : unknown


Subject    : libata: PATA UDMA/100 configured as UDMA/33
References : http://lkml.org/lkml/2007/2/20/294
             http://www.mail-archive.com/linux-ide@vger.kernel.org/msg04115.html
             http://bugzilla.kernel.org/show_bug.cgi?id=8133
             http://bugzilla.kernel.org/show_bug.cgi?id=8164
Submitter  : Fabio Comolli <fabio.comolli@gmail.com>
             Plamen Petrov <plamen.petrov@tk.ru.acad.bg>
             Laurent Riffard <laurent.riffard@free.fr>
Handled-By : Tejun Heo <htejun@gmail.com>
             Alan Cox <alan@lxorguk.ukuu.org.uk>
Status     : Alan: Some cases should be fixed now but probably not all
                   (eg the Nvidia one)



