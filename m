Return-Path: <linux-kernel-owner+w=401wt.eu-S933331AbXCMMvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933331AbXCMMvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 08:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753254AbXCMMuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 08:50:12 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:57975 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753246AbXCMMuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 08:50:04 -0400
Date: Tue, 13 Mar 2007 13:50:06 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Vladimir Brik <no.hope@gmail.com>, Andi Kleen <ak@muc.de>,
       gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz,
       Randy Dunlap <randy.dunlap@oracle.com>, lenb@kernel.org,
       linux-acpi@vger.kernel.org, Ray Lee <ray-lk@madrabbit.org>,
       Colchao <colchaodemola@gmail.com>,
       Mathieu =?utf-8?Q?B=C3=A9rard?= <Mathieu.Berard@crans.org>,
       Tejun Heo <htejun@gmail.com>, jgarzik@pobox.com,
       linux-ide@vger.kernel.org,
       Michal Jaegermann <michal@ellpspace.math.ualberta.ca>,
       Fabio Comolli <fabio.comolli@gmail.com>,
       Plamen Petrov <plamen.petrov@tk.ru.acad.bg>,
       Laurent Riffard <laurent.riffard@free.fr>
Subject: [3/6] 2.6.21-rc3: known regressions
Message-ID: <20070313125006.GT18731@stusta.de>
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This email lists some known regressions in Linus' tree compared to 2.6.20.

If you find your name in the Cc header, you are either submitter of one
of the bugs, maintainer of an affectected subsystem or driver, a patch
of you caused a breakage or I'm considering you in any other way
possibly involved with one or more of these issues.

Due to the huge amount of recipients, please trim the Cc when answering.


Subject    : AMD Elan: Crash after "Allocating PCI resources"
References : http://bugzilla.kernel.org/show_bug.cgi?id=8161
Submitter  : Vladimir Brik <no.hope@gmail.com>
Handled-By : Andi Kleen <ak@muc.de>
Status     : problem is being debugged


Subject    : x86_64: boot hangs unless CONFIG_PCIEPORTBUS=n and acpi=off
References : http://bugzilla.kernel.org/show_bug.cgi?id=8162
Submitter  : Randy Dunlap <randy.dunlap@oracle.com>
Status     : unknown


Subject    : ACPI regression with noapic
References : http://lkml.org/lkml/2007/3/8/468
Submitter  : Ray Lee <ray-lk@madrabbit.org>
Status     : unknown


Subject    : acpi_serialize locks system during boot
References : http://bugzilla.kernel.org/show_bug.cgi?id=8171
Submitter  : Colchao <colchaodemola@gmail.com>
Status     : unknown


Subject    : NCQ problem with ahci and Hitachi drive  (ACPI related)
References : http://lkml.org/lkml/2007/3/4/178
             http://lkml.org/lkml/2007/3/9/475
Submitter  : Mathieu Bérard <Mathieu.Berard@crans.org>
Handled-By : Tejun Heo <htejun@gmail.com>
Status     : unknown


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
Status     : patch available



