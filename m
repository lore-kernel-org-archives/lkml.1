Return-Path: <linux-kernel-owner+w=401wt.eu-S935135AbZAPBRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935135AbZAPBRV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 20:17:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754623AbZAPBRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 20:17:11 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:26729 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545AbZAPBRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 20:17:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=LED8SpLRtlZhhsWKQpUPe3oVVgLbr6bv2Hugg3AqscU5Evidi+2qraxO5XN+Rc7q1C
         GOCyvzXssRTzn96E3FGE/pyJgnZk/SHFFXUplf6vPe4kSYXs26m9ctI5I+iL216nIC6M
         brzKBhm/U48YfaMRAZyHj6OpAeOM9eiALZtuQ=
MIME-Version: 1.0
Date: Fri, 16 Jan 2009 09:17:09 +0800
Message-ID: <a0adeea50901151717v562fb5a9oaf5d80b4bf559d05@mail.gmail.com>
Subject: WARNING: at drivers/usb/storage/transport.c:584
From: Grissiom <chaos.proton@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the last git version of kernel, when I copy some data to a USB disk
I got this WARNING:

[ 6394.109641] ------------[ cut here ]------------
[ 6394.109655] WARNING: at drivers/usb/storage/transport.c:584
last_sector_hacks+0x139/0x190()
[ 6394.109662] Hardware name: Inspiron 1501
[ 6394.109670] sdb: Successful last sector success at 1993648, device
10d6:1101:0100
[ 6394.109676] Modules linked in: fuse ricoh_mmc b43
[ 6394.109693] Pid: 6937, comm: usb-storage Not tainted
2.6.29-rc1-g14-rfkill-nophy-ledon-00224-ga652504 #68
[ 6394.109700] Call Trace:
[ 6394.109715]  [<c012a099>] warn_slowpath+0x99/0xc0
[ 6394.109727]  [<c014e3c7>] mark_held_locks+0x67/0x80
[ 6394.109738]  [<c04dc560>] _spin_unlock_irq+0x20/0x40
[ 6394.109746]  [<c014e5d9>] trace_hardirqs_on_caller+0x149/0x1a0
[ 6394.109754]  [<c04dc500>] _spin_unlock_irqrestore+0x20/0x60
[ 6394.109763]  [<c04d9101>] wait_for_common+0xf1/0x120
[ 6394.109775]  [<c0125c20>] default_wake_function+0x0/0x10
[ 6394.109783]  [<c0381e9e>] usb_stor_msg_common+0xde/0x140
[ 6394.109792]  [<c0381d69>] last_sector_hacks+0x139/0x190
[ 6394.109802]  [<c0382d95>] usb_stor_invoke_transport+0x1f5/0x2a0
[ 6394.109810]  [<c014e3c7>] mark_held_locks+0x67/0x80
[ 6394.109818]  [<c04dc560>] _spin_unlock_irq+0x20/0x40
[ 6394.109826]  [<c014e5d9>] trace_hardirqs_on_caller+0x149/0x1a0
[ 6394.109834]  [<c0383474>] usb_stor_control_thread+0x154/0x1d0
[ 6394.109843]  [<c04dc1cb>] _spin_lock_irqsave+0x4b/0x60
[ 6394.109851]  [<c04dc52c>] _spin_unlock_irqrestore+0x4c/0x60
[ 6394.109860]  [<c0383320>] usb_stor_control_thread+0x0/0x1d0
[ 6394.109868]  [<c014e5d9>] trace_hardirqs_on_caller+0x149/0x1a0
[ 6394.109876]  [<c0383320>] usb_stor_control_thread+0x0/0x1d0
[ 6394.109885]  [<c013def2>] kthread+0x42/0x70
[ 6394.109893]  [<c013deb0>] kthread+0x0/0x70
[ 6394.109902]  [<c0103c03>] kernel_thread_helper+0x7/0x14
[ 6394.109909] ---[ end trace fd10fd16313bc8b9 ]---

Since there is no change in drivers/usb/storage/transport.c in the
newest git, I think the problem is still there. Have some one any
advise? Thanks

--
Cheers,
Grissiom
