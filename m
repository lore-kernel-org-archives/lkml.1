Return-Path: <linux-kernel-owner+w=401wt.eu-S1752126AbXCEBvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbXCEBvO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 20:51:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159AbXCEBvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 20:51:13 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:50022 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751677AbXCEBuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 20:50:39 -0500
Date: Mon, 5 Mar 2007 02:50:39 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Nelless <andrew@nelless.net>, Len Brown <len.brown@intel.com>,
       "Antonino A. Daplas" <adaplas@gmail.com>, linux-acpi@vger.kernel.org,
       Jiri Kosina <jikos@jikos.cz>, Richard Purdie <rpurdie@rpsys.net>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Yaroslav Halchenko <kernel@onerussian.com>,
       Alex Romosan <romosan@sycorax.lbl.gov>,
       David Miller <davem@davemloft.net>,
       James Simmons <jsimmons@infradead.org>, benh@kernel.crashing.org,
       Andreas Schwab <schwab@suse.de>
Subject: [4/6] 2.6.21-rc2: known regressions
Message-ID: <20070305015039.GI3441@stusta.de>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
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


Subject    : Asus A8N-VM motherboard:
             framebuffer/console boot failure boot failure (ACPI related)
References : http://lkml.org/lkml/2007/2/23/132
Submitter  : Andrew Nelless <andrew@nelless.net>
Caused-By  : Len Brown <len.brown@intel.com>
             commit 7f8f97c3cc75d5783d0b45cf323dedf17684be19
Handled-By : Antonino A. Daplas <adaplas@gmail.com>
Status     : problem is being debugged


Subject    : LCD is dimmed  (ibm-acpi related)
References : http://lkml.org/lkml/2007/2/25/206
Submitter  : Jiri Kosina <jikos@jikos.cz>
Caused-By  : Richard Purdie <rpurdie@rpsys.net>
             commit 994efacdf9a087b52f71e620b58dfa526b0cf928
Handled-By : Jiri Kosina <jikos@jikos.cz>
             Richard Purdie <rpurdie@rpsys.net>
             Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Status     : patches are being discussed


Subject    : no backlight on radeon
References : http://lkml.org/lkml/2007/2/19/1
Submitter  : Yaroslav Halchenko <kernel@onerussian.com>
             Alex Romosan <romosan@sycorax.lbl.gov>
             David Miller <davem@davemloft.net>
Caused-By  : James Simmons <jsimmons@infradead.org>
             commit e0e34ef7f02915cfe50e501e9f32c24217177a96
Handled-By : Richard Purdie <rpurdie@rpsys.net>
             James Simmons <jsimmons@infradead.org>
             Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Status     : problem is being discussed


Subject    : nvidiafb broken
References : http://lkml.org/lkml/2007/2/24/36
Submitter  : Andreas Schwab <schwab@suse.de>
Caused-By  : Richard Purdie <rpurdie@rpsys.net>
             commit 599a52d12629394236d785615808845823875868
Handled-By : Richard Purdie <rpurdie@rpsys.net>
Patch      : http://lkml.org/lkml/2007/2/26/43
Status     : patch available


