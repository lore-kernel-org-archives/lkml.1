Return-Path: <linux-kernel-owner+w=401wt.eu-S1754598AbYGXUvC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbYGXUvC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 16:51:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbYGXUux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 16:50:53 -0400
Received: from outbound-mail-128.bluehost.com ([67.222.38.28]:55703 "HELO
	outbound-mail-128.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751301AbYGXUux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 16:50:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=rHhp9l3L9/hzGSd+Ku3NQ9irBvfp7t6BBfT1bmPiP/SnoCzW5/O5UCuXo5tJDfQ37WhCBsk1c41ykIDDVhsnvefippdjPGLiIbBcvzFgzjqdaoGVmkmtb0jkY5YYT5X3;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] more 2.6.27 PCI bits
Date: Thu, 24 Jul 2008 13:50:48 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807241350.48482.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull my for-linus branch:
git pull git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git for-linus

It doesn't contain anything particularly exciting since it looks like we'll
have to wait until 2.6.28 for the resource allocation improvements.
Shortlog & diffstat below.

Thanks,
Jesse

Alex Chiang (1):
      PCI hotplug: fix error path in pci_slot's register_slot

Harvey Harrison (1):
      PCI: fixup sparse endianness warnings in proc.c

Rafael J. Wysocki (1):
      PCI PM: make more PCI PM core functionality available to drivers

Yong Wang (1):
      PCI/DMAR: don't assume presence of RMRRs

 drivers/acpi/pci_slot.c |    5 +++--
 drivers/pci/dmar.c      |    4 +---
 drivers/pci/pci.c       |   34 ++++++++++++++++++++++++----------
 drivers/pci/proc.c      |   18 +++++++++---------
 include/linux/pci.h     |    2 ++
 5 files changed, 39 insertions(+), 24 deletions(-)
