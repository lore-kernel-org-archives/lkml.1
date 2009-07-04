Return-Path: <linux-kernel-owner+w=401wt.eu-S1753414AbZGDUoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbZGDUoU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 16:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbZGDUoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 16:44:11 -0400
Received: from ioctl.codeblau.de ([80.190.240.67]:44285 "EHLO codeblau.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750901AbZGDUoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 16:44:11 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Sat, 04 Jul 2009 16:44:10 EDT
Date: Sat, 4 Jul 2009 22:37:32 +0200
From: Felix von Leitner <felix-linuxkernel@fefe.de>
To: Linux Kernel Mailing list <linux-kernel@vger.kernel.org>
Subject: Core i7 not scaling frequency down
Message-ID: <20090704203732.GA20170@codeblau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just got a Nehalem CPU and it works OK except that the fans are always
running full power and it produces heat like an oven.

  $ cat /proc/acpi/processor/P001/info
  processor id:            0
  acpi id:                 1
  bus mastering control:   yes
  power management:        yes
  throttling control:      no
  limit interface:         no
  $

Oh, no throttling and no limit support?  How can this be?  I'm using
2.6.30 but this appears to be bogus; Windows scales down the CPU
frequency OK.

Does this mean my BIOS ACPI tables are bogus?

I get this message at boot time, but it appears to be unrelated:

  ACPI Warning (tbutils-0246): Incorrect checksum in table [OEMB] - 00, should be FE [20090320]

Any ideas what I could do now to get the CPU to slow down?

Thanks,

Felix
