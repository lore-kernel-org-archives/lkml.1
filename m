Return-Path: <linux-kernel-owner+w=401wt.eu-S1761233AbYETRvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761233AbYETRvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 13:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755869AbYETRvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 13:51:15 -0400
Received: from outbound-mail-119.bluehost.com ([69.89.22.19]:56689 "HELO
	outbound-mail-119.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754719AbYETRvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 13:51:14 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] PCI fixes
Date: Tue, 20 May 2008 10:51:09 -0700
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805201051.09720.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull the PCI fixes:
git pull git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git for-linus

We're still tracking down a couple of PCI hotplug regressions (there's a new
delay at probe time and drivers fighting over ports), so this won't be the
last pull request, but I wanted to get this HP fix upstream.  This pull also
includes an update for the PCI error list entry in MAINTAINERS; I forgot to
update it when linux-pci@ moved.

Thanks,
Jesse

Jesse Barnes (1):
      PCI: correct mailing list address

Tony Camuso (1):
      PCI: Correct last two HP entries in the bfsort whitelist


 MAINTAINERS           |    2 +-
 arch/x86/pci/common.c |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)
