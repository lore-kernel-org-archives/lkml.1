Return-Path: <linux-kernel-owner+w=401wt.eu-S1750948AbXAXPus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750948AbXAXPus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 10:50:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbXAXPus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 10:50:48 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:2080 "HELO
	mailout.stusta.mhn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750948AbXAXPur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 10:50:47 -0500
Date: Wed, 24 Jan 2007 16:50:53 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       =?utf-8?B?QmrDtnJu?= Steinbrink <B.Steinbrink@gmx.de>,
       Robert Hancock <hancockr@shaw.ca>, jgarzik@pobox.com,
       linux-ide@vger.kernel.org,
       Michael Gernoth <gernoth@informatik.uni-erlangen.de>,
       Daniel Drake <dsd@gentoo.org>, David L Stevens <dlstevens@us.ibm.com>,
       YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>, davem@davemloft.net,
       netdev@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Dave Jones <davej@redhat.com>, cpufreq@lists.linux.org.uk,
       lenb@kernel.org, linux-acpi@vger.kernel.org
Subject: 2.6.20-rc5: known regressions with patches (v3)
Message-ID: <20070124155053.GL17836@stusta.de>
References: <Pine.LNX.4.64.0701121424520.11200@woody.osdl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0701121424520.11200@woody.osdl.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This email lists some known regressions in 2.6.20-rc5 compared to 2.6.19
with patches available.

If you find your name in the Cc header, you are either submitter of one
of the bugs, maintainer of an affectected subsystem or driver, a patch
of you caused a breakage or I'm considering you in any other way possibly
involved with one or more of these issues.

Due to the huge amount of recipients, please trim the Cc when answering.


Subject    : sata_nv: SATA exceptions
References : http://lkml.org/lkml/2007/1/14/108
Submitter  : Björn Steinbrink <B.Steinbrink@gmx.de>
Caused-By  : Robert Hancock <hancockr@shaw.ca>
             commit 2dec7555e6bf2772749113ea0ad454fcdb8cf861
Handled-By : Robert Hancock <hancockr@shaw.ca>
Patch      : http://lkml.org/lkml/2007/1/23/280
Status     : patch available


Subject    : does not pickup ipv6 addresses
References : http://bugzilla.kernel.org/show_bug.cgi?id=7817
             http://lkml.org/lkml/2007/1/14/146
Submitter  : Michael Gernoth <gernoth@informatik.uni-erlangen.de>
             Daniel Drake <dsd@gentoo.org>
Caused-By  : David L Stevens <dlstevens@us.ibm.com>
             commit 30c4cf577fb5b68c16e5750d6bdbd7072e42b279
Handled-By : YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Patch      : http://bugzilla.kernel.org/show_bug.cgi?id=7817
Status     : patch available


Subject    : ACPI: fix cpufreq regression
References : http://lkml.org/lkml/2007/1/16/120
Submitter  : Ingo Molnar <mingo@elte.hu>
Caused-By  : Dave Jones <davej@redhat.com>
             commit 0916bd3ebb7cefdd0f432e8491abe24f4b5a101e
Handled-By : Ingo Molnar <mingo@elte.hu>
Patch      : http://lkml.org/lkml/2007/1/16/120
Status     : patch available


