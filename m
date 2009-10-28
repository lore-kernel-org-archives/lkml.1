Return-Path: <linux-kernel-owner+w=401wt.eu-S1755370AbZJ1SWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbZJ1SWb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 14:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751707AbZJ1SWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 14:22:30 -0400
Received: from outbound-mail-36.bluehost.com ([69.89.20.190]:36200 "HELO
	outbound-mail-36.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751506AbZJ1SWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 14:22:30 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Oct 2009 14:22:29 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=O5ckbpAkpITl/3dSbm25Qrqu3WiGG5NtBBxHW/gBIGyE+jOcAYVMxCjxYBTEeF2brAg8QQMVCw2HE1wKc67KHhWMz7Sb6chm5Rg+d2lGguyVDjr9lECKsxHcBA+OXtxp;
Date: Wed, 28 Oct 2009 11:15:44 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] PCI fix
Message-ID: <20091028111544.503c5a31@jbarnes-g45>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just one revert for something Yinghai is already working on fixing up.

The following changes since commit 964fe080d94db82a3268443e9b9ece4c60246414:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../rusty/linux-2.6-for-linus

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 for-linus

Jesse Barnes (1):
      Revert "PCI: get larger bridge ranges when space is available"

 drivers/pci/setup-bus.c |   13 ++-----------
 1 files changed, 2 insertions(+), 11 deletions(-)
