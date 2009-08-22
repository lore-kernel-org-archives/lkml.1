Return-Path: <linux-kernel-owner+w=401wt.eu-S933321AbZHVTLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933321AbZHVTLc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 15:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933309AbZHVTLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 15:11:31 -0400
Received: from outbound-mail-11.bluehost.com ([69.89.18.111]:46365 "HELO
	outbound-mail-11.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933297AbZHVTLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 15:11:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=aVEdghpzoc3M0d+qVhIG0s+ALX2qKk99MDFdggwrkphFjAQW323bf/3/WhBfXkIwLmXx6F8E+tsDpikKRbT37PwaS+eWeMDQbLzYrvhIfq4oaJnHB8XCyNhiKF5LcFJk;
Date: Sat, 22 Aug 2009 12:04:48 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] PCI fix
Message-ID: <20090822120448.2e36bb93@jbarnes-g45>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6c30c53fd5ae6a99a23ad78e90c428d2c8ffb07f:
Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../ryusuke/nilfs2

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 for-linus

Just one fix here that turns out to fix a suspend/resume regression.  It is a
core change though, and I'm a little nervous about pushing it at this point.
So feel free to ignore it if you think it's too risky; we can always land it
in 2.6.31.1 during the merge window instead (to get it a little more coverage
first).

Alek Du (1):
      PCI: check saved state before restore

 drivers/pci/pci-driver.c |    2 +-
 drivers/pci/pci.c        |    2 ++
 2 files changed, 3 insertions(+), 1 deletions(-)

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
