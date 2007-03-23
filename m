Return-Path: <linux-kernel-owner+w=401wt.eu-S1753333AbXCWSsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbXCWSsb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 14:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753326AbXCWSs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 14:48:26 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:32864 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753317AbXCWSsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 14:48:25 -0400
Date: Fri, 23 Mar 2007 19:48:28 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Jaegermann <michal@ellpspace.math.ualberta.ca>, lenb@kernel.org,
       linux-acpi@vger.kernel.org, Ray Lee <ray-lk@madrabbit.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu =?utf-8?Q?B=C3=A9rard?= <Mathieu.Berard@crans.org>,
       Tejun Heo <htejun@gmail.com>, jgarzik@pobox.com,
       linux-ide@vger.kernel.org, Fabio Comolli <fabio.comolli@gmail.com>,
       Plamen Petrov <plamen.petrov@tk.ru.acad.bg>,
       Laurent Riffard <laurent.riffard@free.fr>,
       Lukas Hejtmanek <xhejtman@mail.muni.cz>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [2/5] 2.6.21-rc4: known regressions (v2)
Message-ID: <20070323184828.GP752@stusta.de>
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


Subject    : kernels fail to boot with drives on ATIIXP controller
             (ACPI/IRQ related)
References : https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=229621
             http://lkml.org/lkml/2007/3/4/257
Submitter  : Michal Jaegermann <michal@ellpspace.math.ualberta.ca>
Status     : unknown


Subject    : x86_64: ACPI regression with noapic  (APICTIMER_STOPS_ON_C3?)
References : http://lkml.org/lkml/2007/3/8/468
             http://lkml.org/lkml/2007/3/22/156
Submitter  : Ray Lee <ray-lk@madrabbit.org>
Handled-By : Thomas Gleixner <tglx@linutronix.de>
Status     : problem is being debugged


Subject    : NCQ problem with ahci and Hitachi drive  (ACPI related)
References : http://lkml.org/lkml/2007/3/4/178
             http://lkml.org/lkml/2007/3/9/475
Submitter  : Mathieu Bérard <Mathieu.Berard@crans.org>
Handled-By : Tejun Heo <htejun@gmail.com>
Status     : problem is being debugged


Subject    : libata: PATA UDMA/100 configured as UDMA/33
References : http://lkml.org/lkml/2007/2/20/294
             http://www.mail-archive.com/linux-ide@vger.kernel.org/msg04115.html
             http://bugzilla.kernel.org/show_bug.cgi?id=8133
             http://bugzilla.kernel.org/show_bug.cgi?id=8164
             http://lkml.org/lkml/2007/3/21/330
Submitter  : Fabio Comolli <fabio.comolli@gmail.com>
             Plamen Petrov <plamen.petrov@tk.ru.acad.bg>
             Laurent Riffard <laurent.riffard@free.fr>
             Lukas Hejtmanek <xhejtman@mail.muni.cz>
Handled-By : Tejun Heo <htejun@gmail.com>
             Alan Cox <alan@lxorguk.ukuu.org.uk>
Status     : Alan: Some cases should be fixed now but probably not all
                   (eg the Nvidia one)


