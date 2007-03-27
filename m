Return-Path: <linux-kernel-owner+w=401wt.eu-S1752367AbXC0B7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367AbXC0B7y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 21:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752982AbXC0B7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 21:59:54 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:35507 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752357AbXC0B7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 21:59:32 -0400
Date: Tue, 27 Mar 2007 03:59:36 +0200
From: Adrian Bunk <bunk@stusta.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       davej@codemonkey.org.uk, cpufreq@lists.linux.org.uk,
       Michal Jaegermann <michal@ellpspace.math.ualberta.ca>,
       jgarzik@pobox.com, linux-ide@vger.kernel.org, lenb@kernel.org,
       linux-acpi@vger.kernel.org,
       Mathieu =?utf-8?Q?B=C3=A9rard?= <Mathieu.Berard@crans.org>,
       Tejun Heo <htejun@gmail.com>, Fabio Comolli <fabio.comolli@gmail.com>,
       Plamen Petrov <plamen.petrov@tk.ru.acad.bg>,
       Laurent Riffard <laurent.riffard@free.fr>,
       Lukas Hejtmanek <xhejtman@mail.muni.cz>
Subject: [2/5] 2.6.21-rc5: known regressions
Message-ID: <20070327015936.GZ16477@stusta.de>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This email lists some known regressions in Linus' tree compared to 2.6.20.

If you find your name in the Cc header, you are either submitter of one
of the bugs, maintainer of an affectected subsystem or driver, a patch
of you caused a breakage or I'm considering you in any other way
possibly involved with one or more of these issues.

Due to the huge amount of recipients, please trim the Cc when answering.


Subject    : x86_64 SMP kernel: maxcpus=1 crash in cpufreq
References : http://lkml.org/lkml/2007/3/26/54
Submitter  : Ingo Molnar <mingo@elte.hu>
Handled-By : Venki Pallipadi <venkatesh.pallipadi@intel.com>
Status     : problem is being debugged


Subject    : kernels fail to boot with drives on ATIIXP controller
             (ACPI/IRQ related)
References : https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=229621
             http://lkml.org/lkml/2007/3/4/257
Submitter  : Michal Jaegermann <michal@ellpspace.math.ualberta.ca>
Status     : unknown


Subject    : NCQ problem with ahci and Hitachi drive  (ACPI related)
References : http://lkml.org/lkml/2007/3/4/178
             http://lkml.org/lkml/2007/3/9/475
             http://lkml.org/lkml/2007/2/22/8
Submitter  : Mathieu Bérard <Mathieu.Berard@crans.org>
Handled-By : Tejun Heo <htejun@gmail.com>
Patch      : http://lkml.org/lkml/2007/2/22/8
Status     : possible patch available


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
Patch      : http://thread.gmane.org/gmane.linux.ide/17444
Status     : patch available


