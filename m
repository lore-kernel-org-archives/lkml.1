Return-Path: <linux-kernel-owner+w=401wt.eu-S1753873AbXCaSTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbXCaSTn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 14:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870AbXCaSTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 14:19:43 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:39405 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753865AbXCaSTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 14:19:42 -0400
Date: Sat, 31 Mar 2007 20:19:40 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>,
       Mathieu =?utf-8?Q?B=C3=A9rard?= <Mathieu.Berard@crans.org>,
       Tejun Heo <htejun@gmail.com>, Robert Hancock <hancockr@shaw.ca>,
       jgarzik@pobox.com, linux-ide@vger.kernel.org,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@suse.cz,
       linux-pm@lists.osdl.org, tigran@aivazian.fsnet.co.uk
Subject: 2.6.21-rc5: known regressions with patches (v2)
Message-ID: <20070331181940.GV14134@stusta.de>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This email lists some known regressions in Linus' tree compared to 2.6.20
with patches available.

If you find your name in the Cc header, you are either submitter of one
of the bugs, maintainer of an affectected subsystem or driver, a patch
of you caused a breakage or I'm considering you in any other way
possibly involved with one or more of these issues.

Due to the huge amount of recipients, please trim the Cc when answering.


Subject    : hung bootup in various drivers
References : http://lkml.org/lkml/2007/3/30/68
Submitter  : Ingo Molnar <mingo@elte.hu>
Handled-By : Kay Sievers <kay.sievers@vrfy.org>
Patch      : http://lkml.org/lkml/2007/3/30/323
Status     : patch available


Subject    : NCQ problem with ahci and Hitachi drive
References : http://lkml.org/lkml/2007/3/4/178
             http://lkml.org/lkml/2007/3/9/475
             http://lkml.org/lkml/2007/2/22/8
Submitter  : Mathieu Bérard <Mathieu.Berard@crans.org>
Handled-By : Tejun Heo <htejun@gmail.com>
             Robert Hancock <hancockr@shaw.ca>
Patch      : http://lkml.org/lkml/2007/2/22/8
Status     : possible patch available


Subject    : suspend to disk hangs  (microcode driver)
References : http://lkml.org/lkml/2007/3/16/126
Submitter  : Maxim Levitsky <maximlevitsky@gmail.com>
Caused-By  : Rafael J. Wysocki <rjw@sisk.pl>
             commit e3c7db621bed4afb8e231cb005057f2feb5db557
             commit ed746e3b18f4df18afa3763155972c5835f284c5
             commit 259130526c267550bc365d3015917d90667732f1
Handled-By : Rafael J. Wysocki <rjw@sisk.pl>
Patch      : http://lkml.org/lkml/2007/3/25/71
Status     : patch available

