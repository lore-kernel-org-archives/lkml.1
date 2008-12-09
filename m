Return-Path: <linux-kernel-owner+w=401wt.eu-S1755265AbYLIWs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265AbYLIWs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 17:48:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754708AbYLIWsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 17:48:17 -0500
Received: from outbound-mail-17.bluehost.com ([69.89.20.232]:53556 "HELO
	outbound-mail-17.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754691AbYLIWsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 17:48:16 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Dec 2008 17:48:16 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=k6k1c0LTMa5PRa/P+939Sah4xD1dopBiwa+TMb3qKVH6T+pnCYtLhwCDnjzUaW7ISp2lvM3CTRn9r/YVjJ0vXU65EQen8oAeThINUaaWyQCtGOmLLy/qDRwWeexlvb46;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: PCI fix
Date: Tue, 9 Dec 2008 14:41:14 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.5-41.fc9.x86_64; KDE/4.1.3; x86_64; ; )
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812091441.14250.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 216.239.45.19 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull my for-linus branch:
git pull git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git for-linus

One more last minute fix for a small memory leak from Alex.

-- 
Jesse Barnes, Intel Open Source Technology Center

Alex Chiang (1):
      PCI: stop leaking 'slot_name' in pci_create_slot

 drivers/pci/slot.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

