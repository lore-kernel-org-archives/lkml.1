Return-Path: <linux-kernel-owner+w=401wt.eu-S1754281AbXDWVsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbXDWVsu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 17:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754260AbXDWVst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 17:48:49 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:60319 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754240AbXDWVsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 17:48:47 -0400
Date: Mon, 23 Apr 2007 23:48:57 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Olaf Kirch <okir@lst.de>, lenb@kernel.org, linux-acpi@vger.kernel.org,
       Michal Jaegermann <michal@ellpspace.math.ualberta.ca>,
       jgarzik@pobox.com, linux-ide@vger.kernel.org,
       Stephen Clark <Stephen.Clark@seclark.us>, netdev@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Robert Peterson <rpeterso@redhat.com>, linux-driver@qlogic.com,
       James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org
Subject: [2/3] 2.6.21-rc7: known regressions (v2)
Message-ID: <20070423214857.GC3468@stusta.de>
References: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This email lists some known regressions in Linus' tree compared to 2.6.20.

If you find your name in the Cc header, you are either submitter of one
of the bugs, maintainer of an affectected subsystem or driver, a patch
of you caused a breakage or I'm considering you in any other way
possibly involved with one or more of these issues.

Due to the huge amount of recipients, please trim the Cc when answering.


Subject    : ACPI: Crashes + hangs during modprobe processor
                   unless "processor.nocst"
References : http://bugzilla.kernel.org/show_bug.cgi?id=8346
Submitter  : Olaf Kirch <okir@lst.de>
Status     : unknown


Subject    : kernels fail to boot with drives on ATIIXP controller
             (ACPI/IRQ related)
References : https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=229621
             http://lkml.org/lkml/2007/3/4/257
Submitter  : Michal Jaegermann <michal@ellpspace.math.ualberta.ca>
Status     : unknown


Subject    : ali_pata: boot from CD fails
References : http://lkml.org/lkml/2007/3/31/160
Submitter  : Stephen Clark <Stephen.Clark@seclark.us>
Status     : unknown


Subject    : boot failure: rtl8139: exception in interrupt routine
References : http://lkml.org/lkml/2007/3/31/160
Submitter  : Stephen Clark <Stephen.Clark@seclark.us>
Status     : unknown


Subject    : qla2xxx driver no longer works
References : http://lkml.org/lkml/2007/4/16/49
             http://lkml.org/lkml/2007/4/20/224
Submitter  : David Miller <davem@davemloft.net>
             Robert Peterson <rpeterso@redhat.com>
Handled-By : David Miller <davem@davemloft.net>
Patch      : http://lkml.org/lkml/2007/4/16/234
Status     : patch was suggested


