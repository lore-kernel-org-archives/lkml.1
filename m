Return-Path: <linux-kernel-owner+w=401wt.eu-S1755120AbZDZOjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120AbZDZOjo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 10:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754272AbZDZOje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 10:39:34 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:61108 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042AbZDZOjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 10:39:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=iBOp0zWLqaudPZbU6nHLmyMKIcO9aY6Bs52/vBek6UFMv0T7vH3t2NdYGLdw0QP3ib
         Y5SgAxo3pCEv052+LMur3h54QYvSQGKCMVA6I8D/FNJH8DPDBnspSW0742Nk/RsJmkoC
         xH1qZ5vQzDyk98SwSj0j7a5SXPkFQYVYcGaC0=
Message-ID: <49F4E29F.8030409@gmail.com>
Date: Mon, 27 Apr 2009 00:39:27 +0200
From: jan sonnek <ha2nny@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090223 Thunderbird/3.0b2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: oops on 2.6.30-rc3-mm1
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I get this oops, when I try to start my X windows (startx)
I have some bug later, but when I switch off some new modules, I was able to start X windows.

Later:
------------

http://bugzilla.kernel.org/show_bug.cgi?id=12619

Now:
------------

BUG: unable to handle kernel NULL pointer dereference at 00000040
IP: [<c015409c>] balance_dirty_pages_ratelimited_nr+0x10/0x29b
*pde = 36b28067 *pte = 00000000
Oops: 0000 [#1] PREEMPT SMP
last sysfs file: /sys/devices/virtual/dmi/id/chassis_asset_tag
Modules linked in: sco bnep l2cap bluetooth coretemp hwmon ipv6 fuse iwl3945 iwlcore sdhci_pci sr_mod sg sdhci ohci1394 ieee1394 cdrom mmc_core battery mac80211 led_class ricoh_mmc cfg80211 usb_storage [last unloaded: scsi_wait_scan]

Pid: 2867, comm: X Not tainted (2.6.30-rc3-mm1-hanny #27) F3F
EIP: 0060:[<c015409c>] EFLAGS: 00213296 CPU: 0
EIP is at balance_dirty_pages_ratelimited_nr+0x10/0x29b
EAX: 00000000 EBX: 00000008 ECX: 00000000 EDX: 00000001
ESI: 00000000 EDI: 5f372067 EBP: f69a1eec ESP: f69a1e84
  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process X (pid: 2867, ti=f69a1000 task=f7164380 task.ti=f69a1000)
Stack:
  f69a1e8c c03691fe f69a1eac 00203292 000000d0 00203292 f7001324 f6ad4474
  000f877d 000f877e f69a1ebc c023ea66 f6b003e0 f6b003e0 f69a1ec4 c03691fe
  f69a1ed8 c017e704 c1be6e40 f6ad43a8 f6823600 00000000 c049f9c0 c1be6e40
Call Trace:
  [<c03691fe>] ? _spin_unlock+0x19/0x24
  [<c023ea66>] ? drm_vm_open_locked+0x5b/0x94
  [<c03691fe>] ? _spin_unlock+0x19/0x24
  [<c017e704>] ? mnt_drop_write+0x6d/0xe6
  [<c015d26c>] ? __do_fault+0x283/0x2bd
  [<c015e784>] ? handle_mm_fault+0x1f7/0x454
  [<c0115472>] ? do_page_fault+0x1e0/0x1ef
  [<c0115292>] ? do_page_fault+0x0/0x1ef
  [<c03694dd>] ? error_code+0x6d/0x74
  [<c0115292>] ? do_page_fault+0x0/0x1ef
Code: e8 af 7a 00 00 89 f0 25 c0 00 00 00 3d c0 00 00 00 74 a1 8d 65 f4 5b 5e 5f c9 c3 55 89 e5 57 56 89 c6 53 bb 08 00 00 00 83 ec 5c <8b> 40 40 83 78 70 00 89 e0 0f 44 1d d8 73 45 c0 25 00 f0 ff ff
EIP: [<c015409c>] balance_dirty_pages_ratelimited_nr+0x10/0x29b SS:ESP 0068:f69a1e84
CR2: 0000000000000040
---[ end trace 84b1cd49fe3274a1 ]---
