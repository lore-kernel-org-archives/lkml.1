Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542Ab0CJKIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 05:08:53 -0500
Received: from mail-ew0-f216.google.com ([209.85.219.216]:41968 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab0CJKIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 05:08:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=flpXhvxKnU4RA9oJmImFcZa/ViwzWOrE2l0kjRkZL06aHr7ft0aayeuru0cEEcnjz8
         6xFtvbTDDQhHADySp9/kD41UGinfIVXGktko6O+RST2wNAlFd+7+UeSJHaP7YJTmJRae
         QQoHabqUlCAHGTlmSvmLXTimoN2NSOcZZ2tNw=
MIME-Version: 1.0
Date: Wed, 10 Mar 2010 11:08:49 +0100
Message-ID: <40a4ed591003100208v67b61ca5sd7a3ab8da99e975e@mail.gmail.com>
Subject: ata1 timeouts on 2.6.34-rc1
From: Zeno Davatz <zdavatz@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am on 2.6.34-r1 and I get the same ATA timeouts as Linus gets here:

http://lkml.org/lkml/2010/3/9/345

ata1: clearing spurious IRQ
ata1: lost interrupt (Status 0x50)
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1.00: failed command: WRITE DMA
ata1.00: cmd ca/00:08:75:98:89/00:00:00:00:00/e3 tag 0 dma 4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.00: status: { DRDY }
ata1: soft resetting link
ata1.00: configured for UDMA/133
ata1.00: device reported invalid CHS sector 0
ata1: EH complete
ata1: clearing spurious IRQ
ata1: lost interrupt (Status 0x50)
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1.00: failed command: READ DMA
ata1.00: cmd c8/00:00:5d:ba:7b/00:00:00:00:00/e4 tag 0 dma 131072 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.00: status: { DRDY }
ata1: soft resetting link
ata1.00: configured for UDMA/133
ata1.00: device reported invalid CHS sector 0
ata1: EH complete
ata1: clearing spurious IRQ
ata1: lost interrupt (Status 0x50)
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1.00: failed command: READ DMA
ata1.00: cmd c8/00:00:7d:7b:7d/00:00:00:00:00/e4 tag 0 dma 131072 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.00: status: { DRDY }
ata1: soft resetting link
ata1.00: configured for UDMA/133
ata1.00: device reported invalid CHS sector 0
ata1: EH complete
ata1: clearing spurious IRQ
ata1: lost interrupt (Status 0x50)
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata1.00: failed command: READ DMA
ata1.00: cmd c8/00:00:1d:a2:68/00:00:00:00:00/ea tag 0 dma 131072 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.00: status: { DRDY }
ata1: soft resetting link
ata1.00: configured for UDMA/133
ata1.00: device reported invalid CHS sector 0
ata1: EH complete

I am also on an Intel SSD (160 GB). Every timeout blocks my PC for some seconds.

Best
Zeno
