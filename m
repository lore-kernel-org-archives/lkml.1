Return-Path: <linux-kernel-owner+w=401wt.eu-S1760280AbZCPTPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760280AbZCPTPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 15:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753609AbZCPTPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 15:15:42 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:38547 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbZCPTPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 15:15:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=pFcGraGaqHovYudrvutLWk7zXQ1VIdkpSeHthgzDELKsy68sDA5zpTtmIFyCqv3ydy
         oDQwV1gow0OehpKPiHOxdPkQFffO2DhiXMtzKilIsE9MFLEzUE+ePtRGgHF/JBw0dlh7
         SW30nHWBvqmgdRGOwKRNSjk2UwKQNUU9H7vhY=
MIME-Version: 1.0
Date: Mon, 16 Mar 2009 12:15:37 -0700
Message-ID: <43e72e890903161215u343cbb19v6d6cbf36794e252a@mail.gmail.com>
Subject: AMD Quad core - PCI-DMA: Out of IOMMU space on > 4 GB RAM
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: wireless <linux-wireless@vger.kernel.org>, joerg.roedel@amd.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       iommu@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've run into "PCI-DMA: Out of IOMMU space" messages after loading and
unloading a module 30 times. The interesting thing is this only
happens if I have > 4 GB of memory. The box this occurs has AMD Phenom
quad core CPU so I take it a harware IOMMU is being used. Below are
example relevant messages with > 4 GB and then < 4 GB of memory. The
driver I tested this with was ath9k. It could be an issue perhaps with
ath9k but I am unable to find an issue in our probe/removal.

Could this be an issue with the AMD IOMMU used? Or is it more likely a
driver issue?

With > 4 GB of RAM:

phy0: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc20011820000, irq=19
phy1: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc20012520000, irq=19
phy2: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc200117a0000, irq=19
phy3: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc200117c0000, irq=19
phy4: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc200117a0000, irq=19
phy5: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc200117c0000, irq=19
phy6: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc200117a0000, irq=19
phy7: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc200117c0000, irq=19
phy8: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc200117a0000, irq=19
phy9: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc200117c0000, irq=19
phy10: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc200117a0000, irq=19
phy11: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc200117c0000, irq=19
phy12: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc200117a0000, irq=19
phy13: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc200117c0000, irq=19
phy14: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc200117a0000, irq=19
phy15: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc200117c0000, irq=19
phy16: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc200117a0000, irq=19
phy17: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc200117c0000, irq=19
phy18: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc200117a0000, irq=19
phy19: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc200117c0000, irq=19
phy20: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc200117a0000, irq=19
phy21: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc200117c0000, irq=19
phy22: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc200117a0000, irq=19
phy23: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc200117c0000, irq=19
phy24: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc200117a0000, irq=19
phy25: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc200117c0000, irq=19
phy26: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc200117a0000, irq=19
phy27: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc200117c0000, irq=19
phy28: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc200117a0000, irq=19
phy29: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc200117c0000, irq=19
phy30: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc200117a0000, irq=19
ath9k 0000:01:06.0: PCI-DMA: Out of IOMMU space for 3904 bytes
ath9k 0000:01:06.0: PCI-DMA: Out of IOMMU space for 3904 bytes
ath9k 0000:01:06.0: PCI-DMA: Out of IOMMU space for 3904 bytes
... etc

The full log can be seen at:

http://bombadil.infradead.org/~mcgrof/logs/log-out-of-mem-full

With < 4GB RAM:

phy0: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc20011200000, irq=19
phy1: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc200125a0000, irq=19
phy2: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc200110a0000, irq=19
phy3: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc20011140000, irq=19
phy4: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc200110a0000, irq=19
phy5: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc20011140000, irq=19
phy6: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc200110a0000, irq=19
phy7: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc20011140000, irq=19
phy8: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc200110a0000, irq=19
phy9: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc20011140000, irq=19
phy10: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc200110a0000, irq=19
phy11: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc20011140000, irq=19
phy12: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc200110a0000, irq=19
phy13: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc20011140000, irq=19
phy14: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc200110a0000, irq=19
phy15: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc20011140000, irq=19
phy16: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc200110a0000, irq=19
phy17: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc20011140000, irq=19
phy18: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc200110a0000, irq=19
phy19: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc20011140000, irq=19
phy20: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc200110a0000, irq=19
phy21: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc20011140000, irq=19
phy22: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc200110a0000, irq=19
phy23: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc20011140000, irq=19
phy24: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc200110a0000, irq=19
phy25: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc20011140000, irq=19
phy26: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc200110a0000, irq=19
phy27: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc20011140000, irq=19
phy28: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc200110a0000, irq=19
phy29: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc20011140000, irq=19
phy30: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc200110a0000, irq=19
phy31: Atheros AR5416 MAC/BB Rev:2 AR2122 RF Rev:81:
mem=0xffffc20011140000, irq=19
..etc goes on and on

The full log can be seen at:

http://bombadil.infradead.org/~mcgrof/logs/log-out-of-mem-full-NOT

  Luis
