Return-Path: <linux-kernel-owner+w=401wt.eu-S1757813AbYJ3QOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757813AbYJ3QOF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 12:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757347AbYJ3QM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 12:12:59 -0400
Received: from outbound-mail-160.bluehost.com ([67.222.39.40]:41077 "HELO
	outbound-mail-160.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757341AbYJ3QM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 12:12:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=TJc+Ulk7tjF6YuRqlPF83BaHlNTQGlVkZwDYV2y+1QTQDV8nO6ttCZWVh1MlilthUorEOScG94iS9B+ye8zVXY9UynK3ebqbbhg7eXCmYAx3DCFBV+D7ZF6P5a9B75vp;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] PCI build fix
Date: Thu, 30 Oct 2008 09:12:53 -0700
User-Agent: KMail/1.10.1 (Linux/2.6.26.5-45.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810300912.54111.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull my for-linus branch:
git pull git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git for-linus

Just one minor build fix in this pull.

Thanks,
Jesse

Fenghua Yu (1):
      x86/PCI: build failure at x86/kernel/pci-dma.c with !CONFIG_PCI

 arch/ia64/include/asm/iommu.h |    1 -
 arch/ia64/kernel/pci-dma.c    |    7 -------
 arch/x86/include/asm/iommu.h  |    1 -
 arch/x86/kernel/pci-dma.c     |   16 ++++++++++++++++
 drivers/pci/quirks.c          |   14 --------------
 5 files changed, 16 insertions(+), 23 deletions(-)

