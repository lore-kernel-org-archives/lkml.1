Return-Path: <linux-kernel-owner+w=401wt.eu-S1752662AbYKSWSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662AbYKSWSf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 17:18:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbYKSWS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 17:18:26 -0500
Received: from outbound-mail-116.bluehost.com ([69.89.22.16]:41254 "HELO
	outbound-mail-116.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751395AbYKSWSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 17:18:25 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=cI45mUPFyoOHDoSd2uS51gtSAbd8y9zuVbnKOwUAsYkg/gTn+t8K2PBtnwy+PgGfK8nze86HJtsQ5K2pturGt/sESf/o9bQ8U44SAXyj1QzdcbdcG3ZUyEu/QjbmNDFQ;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] PCI fix
Date: Wed, 19 Nov 2008 14:18:11 -0800
User-Agent: KMail/1.9.10
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811191418.12137.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 65.249.24.81 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull my for-linus branch:
git pull git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git for-linus

Another small fix for 2.6.28.  If not fixed, this bug could end up causing
IRQ 0 to get disabled when a PCI function is reset before init.

Thanks,
Jesse

Sheng Yang (1):
      PCI: Fix disable IRQ 0 in pci_reset_function()


 drivers/pci/pci.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)
