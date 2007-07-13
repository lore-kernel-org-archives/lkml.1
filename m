Return-Path: <linux-kernel-owner+w=401wt.eu-S935694AbXGMWoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935694AbXGMWoh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 18:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758647AbXGMWoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 18:44:30 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:59063 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756500AbXGMWo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 18:44:29 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/12] drivers/isdn: replace pci_find_device with pci_get_device
Date: Sat, 14 Jul 2007 01:44:12 +0300
User-Agent: KMail/1.9.7
Cc: kkeil@suse.de, kai.germaschewski@gmx.de, isdn4linux@listserv.isdn4linux.de
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <200707140144.14644.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi;

Following patches replaces pci_find_device with pci_get_device (with some 
whitespace cleanups) to avoid following warnings;

warning: `pci_find_device' is deprecated (declared at include/linux/pci.h:478)

occured while compiling the kernel for ages.

Although ISDN subsystem marked as Maintained, last activity on ISDN 
subsystem's git tree occured 21 Month ago :( so for this reason i'm adding 
LKML also.

[1] http://git.kernel.org/?p=linux/kernel/git/kkeil/isdn-2.6.git;a=summary

Cheers
-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
