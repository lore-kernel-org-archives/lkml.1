Return-Path: <linux-kernel-owner+w=401wt.eu-S1757361AbXD0VrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361AbXD0VrO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 17:47:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757341AbXD0VrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 17:47:14 -0400
Received: from gherkin.frus.com ([192.158.254.49]:59503 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757358AbXD0VrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 17:47:11 -0400
Subject: BAD_SG_DMA panic in aha1542
To: linux-kernel@vger.kernel.org
Date: Fri, 27 Apr 2007 16:47:09 -0500 (CDT)
CC: linux-scsi@vger.kernel.org
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20070427214709.DC44BDBA2@gherkin.frus.com>
From: rct@gherkin.frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I previously reported an ISA DMA issue for the 2.6.12 kernel.  The issue
persists through at least 2.6.18.  SCSI controller is an Adaptec
AHA-1542B (ISA).

The action "mount -t iso9660 /dev/scd0 /mnt/cdrom -r"

produces

(cdrom detection messages as various modules autoload, then...)
sgpnt[0:1] page c1ee5af0/0x1ee5af0 length 32
Kernel panic - not syncing: Buffer at physical address > 16 Mb used for aha1542

As before, no problems using the sda hard disk (which is the boot drive):
everything works reliably until I touch the cdrom drive.

I'll be happy to assist with the debugging, but the system with the
aha1542 has no development facilities, i.e., I'll have to build test
kernels on a different system, and turnaround is going to be slow :-(.

Thanks in advance for helping me get this old machine working again.
No issues with 2.4 kernels.  I have no idea about 2.5 kernels and
2.6 kernels prior to 2.6.12.  As for why I didn't report this before
now, the aha1542b was in my parts bin until I cobbled a system together
approx. two weeks ago, mostly to see if a useful system could still be
had using legacy hardware and modern GNU/Linux software.  I'm happy to
report the answer is mostly "yes".

-- 
-----------------------------------------------------------------------
Bob Tracy                   WTO + WIPO = DMCA? http://www.anti-dmca.org
rct@frus.com
-----------------------------------------------------------------------
