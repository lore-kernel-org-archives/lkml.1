Return-Path: <linux-kernel-owner+w=401wt.eu-S1757113AbZKKIME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113AbZKKIME (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 03:12:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757074AbZKKIMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 03:12:03 -0500
Received: from outbound-mail-11.bluehost.com ([69.89.18.111]:59820 "HELO
	outbound-mail-11.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757077AbZKKIMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 03:12:02 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=DUD2mVQNG/R2Jh7zF7Us6AqKDWlqIFtYdJBoHPdFy0RXx//wUa+vazHepU0ngkFVZvPf2lOyTab/86bWsvy1x3Xse8Jh1//XHpsfkVAolLaP/SWksx2N3rZ1xfqXBiPS;
Date: Wed, 11 Nov 2009 08:12:01 +0000
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] PCI fixes
Message-ID: <20091111081201.2f5344bb@jbarnes-x200>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 158.43.2.102 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a few more fixes for 2.6.32.  There's still one outstanding patch
(from you for the prefetchable resource allocation issue) that I'm
integrating now.

The following changes since commit 91d3f9bacdb4950d2f79fe2ba296aa249f60d06c:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../anholt/drm-intel

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 for-linus

Jan Beulich (1):
      x86/PCI: Adjust GFP mask handling for coherent allocations

Kenji Kaneshige (1):
      PCI ASPM: fix oops on root port removal

 arch/x86/include/asm/dma-mapping.h |   10 +++++++---
 arch/x86/kernel/pci-dma.c          |    6 ++----
 drivers/pci/pcie/aspm.c            |    6 ++++--
 3 files changed, 13 insertions(+), 9 deletions(-)
