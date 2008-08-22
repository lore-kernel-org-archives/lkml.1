Return-Path: <linux-kernel-owner+w=401wt.eu-S1759819AbYHVJlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759819AbYHVJlg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 05:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753552AbYHVJl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 05:41:28 -0400
Received: from transportmtw1.mindtree.com ([203.200.60.156]:33743 "EHLO
	mail2.mindtree.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752273AbYHVJl1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 05:41:27 -0400
From: Saroj Tripathy <Saroj_Tripathy@mindtree.com>
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
CC: Saroj Tripathy <Saroj_Tripathy@mindtree.com>
Date: Fri, 22 Aug 2008 15:14:01 +0530
Subject: Query on LVM ....
Thread-Topic: Query on LVM ....
Thread-Index: AckEO5tpM3vkilkeQCqjBauA6lPzZg==
Message-ID: <174230991E95D743B0C91DF471EF44E8426495432F@MTW02MSG02.mindtree.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I want to know, is there any way I can find out whether my physical volume is activate or deactivate? For example, I have activated my physical volume group say vg_lvm through "vgchange" command.

# vgchange -a Y vg_lvm

Now, how I will know that "vg_lvm" is activated? Is there any way to query or is any config file changed by executing above command? So that I can look for that file or any sorts of command available?

Below I am showing you the results of vgdisply with a deactivated vol group. The output is same in both activate and deactivate volume group.

[root@mtasw317 ~]# vgchange -a n vg_lvm
0 logical volume(s) in volume group "vg_lvm" now active

[root@mtasw317 ~]# vgdisplay
--- Volume group ---
VG Name vg_lvm
System ID
Format lvm2
Metadata Areas 2
Metadata Sequence No 2
VG Access read/write
VG Status resizable
MAX LV 0
Cur LV 1
Open LV 0
Max PV 0
Cur PV 2
Act PV 2
VG Size 1.12 GB
PE Size 4.00 MB
Total PE 288
Alloc PE / Size 25 / 100.00 MB
Free PE / Size 263 / 1.03 GB
VG UUID ci9mLc-JuVk-pUBV-gtYd-T9F2-LxsC-uLXGcb

The Operating System I am using is RHEL 4. Please help me in finding the solutions.

Regards,
Saroj

This message (including attachment if any) is confidential and may be privileged. If you have received this message by mistake please notify the sender by return e-mail and delete this message from your system. Any unauthorized use or dissemination of this message in whole or in part is strictly prohibited. E-mail may contain viruses. Before opening attachments please check them for viruses and defects. While MindTree Limited (MindTree) has put in place checks to minimize the risks, MindTree will not be responsible for any viruses or defects or any forwarded attachments emanating either from within MindTree or outside.

Please note that e-mails are susceptible to change and MindTree shall not be liable for any improper, untimely or incomplete transmission.

MindTree reserves the right to monitor and review the content of all messages sent to or from MindTree e-mail address. Messages sent to or from this e-mail address may be stored on the MindTree e-mail system or else where.
