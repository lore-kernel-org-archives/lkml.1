Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab0CHXyA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 18:54:00 -0500
Received: from outbound-mail-01.bluehost.com ([69.89.21.11]:48244 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756121Ab0CHXx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 18:53:56 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=IflMSCMwo5oHVws5xILlk9FnK2E+68da/5X0BPRPkUaJKYlz1D782y+pVHsezjemcfT0mkdWSFWBEDooU+xFbvcb6sjYRhVJOyRBZxmVkJOwocj2hEmIXjVALZWQInpa;
Date: Mon, 8 Mar 2010 15:53:31 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] PCI fix
Message-ID: <20100308155331.6724efb7@jbarnes-piketon>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following changes since commit 64096c17417380d8a472d096645f4cbc9406c987:
  Linus Torvalds (1):
        Merge branch 'slab-for-linus' of git://git.kernel.org/.../penberg/slab-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 for-linus

Just one fix from Rafael for the new runtime PM stuff.  A few other
fixes are trickling in now, and I expect more once people start testing
-rc1.

Thanks,
Jesse

Rafael J. Wysocki (1):
      PCI/PM Runtime: Make runtime PM of PCI devices inactive by default

 drivers/pci/pci.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)
