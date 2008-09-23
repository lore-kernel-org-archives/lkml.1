Return-Path: <linux-kernel-owner+w=401wt.eu-S1754662AbYIWTOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbYIWTOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 15:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbYIWTO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 15:14:26 -0400
Received: from outbound-mail-110.bluehost.com ([69.89.22.10]:41767 "HELO
	outbound-mail-110.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752318AbYIWTOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 15:14:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=hGHMy4ZXe/+JuPYhmgZOJOiNfUKfVhqu0S3pJDTj2B5PlTCVXqutYGdH55/WdQ7nYjk/aJChyq3HKzLRvTEAzQbpKR5wLui5uDCvmKzxfySNohnFJ1ovyJ6XvqVPVgAd;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: [git pull] PCI fixes
Date: Tue, 23 Sep 2008 12:14:22 -0700
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809231214.22858.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull my for-linus branch:
git pull git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git for-linus

Includes a few more regression fixes (compiler warnings and a thinko in the
new ASPM option).

Thanks,
Jesse

Greg Kroah-Hartman (1):
      PCI: fix compiler warnings in pci_get_subsys()

Sitsofe Wheeler (1):
      PCI: Fix pcie_aspm=force


 drivers/pci/pcie/aspm.c |    2 +-
 drivers/pci/search.c    |    6 +++---
 include/linux/pci.h     |    8 ++++----
 3 files changed, 8 insertions(+), 8 deletions(-)
