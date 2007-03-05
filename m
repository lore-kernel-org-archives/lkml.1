Return-Path: <linux-kernel-owner+w=401wt.eu-S1752158AbXCEBvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbXCEBvW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 20:51:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbXCEBvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 20:51:15 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:50006 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752048AbXCEBug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 20:50:36 -0500
Date: Mon, 5 Mar 2007 02:50:36 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mathieu =?utf-8?Q?B=C3=A9rard?= <Mathieu.Berard@crans.org>,
       jgarzik@pobox.com, linux-ide@vger.kernel.org,
       Michal Jaegermann <michal@ellpspace.math.ualberta.ca>,
       Fabio Comolli <fabio.comolli@gmail.com>, Tejun Heo <htejun@gmail.com>,
       Janosch Machowinski <jmachowinski@gmx.de>,
       Lukas Hejtmanek <xhejtman@fi.muni.cz>, Meelis Roos <mroos@linux.ee>,
       Olivier Mondoloni <darkcore71@yahoo.fr>,
       Thomas Renninger <trenn@suse.de>, Robert Moore <robert.moore@intel.com>,
       lenb@kernel.org, linux-acpi@vger.kernel.org
Subject: [3/6] 2.6.21-rc2: known regressions
Message-ID: <20070305015036.GH3441@stusta.de>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This email lists some known regressions in 2.6.21-rc2 compared to 2.6.20
that are not yet fixed in Linus' tree.

If you find your name in the Cc header, you are either submitter of one
of the bugs, maintainer of an affectected subsystem or driver, a patch
of you caused a breakage or I'm considering you in any other way
possibly involved with one or more of these issues.

Due to the huge amount of recipients, please trim the Cc when answering.


Subject    : NCQ problem with ahci and Hitachi drive
References : http://lkml.org/lkml/2007/3/4/178
Submitter  : Mathieu Bérard <Mathieu.Berard@crans.org>
Status     : unknown


Subject    : kernels fail to boot with drives on ATIIXP controller
References : https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=229621
Submitter  : Michal Jaegermann <michal@ellpspace.math.ualberta.ca>
Status     : unknown


Subject    : libata: PATA UDMA/100 configured as UDMA/33
References : http://lkml.org/lkml/2007/2/20/294
             http://www.mail-archive.com/linux-ide@vger.kernel.org/msg04115.html
Submitter  : Fabio Comolli <fabio.comolli@gmail.com>
Handled-By : Tejun Heo <htejun@gmail.com>
Status     : problem is being discussed


Subject    : SATA_ACPI errors during kernel boot
References : http://bugzilla.kernel.org/show_bug.cgi?id=8080
             http://bugzilla.kernel.org/show_bug.cgi?id=8046
             http://bugzilla.kernel.org/show_bug.cgi?id=8095
             http://lkml.org/lkml/2007/2/22/159
Submitter  : Janosch Machowinski <jmachowinski@gmx.de>
             Lukas Hejtmanek <xhejtman@fi.muni.cz>
             Meelis Roos <mroos@linux.ee>
             Olivier Mondoloni <darkcore71@yahoo.fr>
Handled-By : Thomas Renninger <trenn@suse.de>
             Tejun Heo <htejun@gmail.com>
             Robert Moore <robert.moore@intel.com>
Status     : problem is being debugged

