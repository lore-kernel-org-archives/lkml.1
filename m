Return-Path: <linux-kernel-owner+w=401wt.eu-S1751977AbZIBMpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbZIBMpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 08:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbZIBMpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 08:45:49 -0400
Received: from mail-vw0-f195.google.com ([209.85.212.195]:37482 "EHLO
	mail-vw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbZIBMps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 08:45:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=lGf/O1NMt9rwBJ3qG96ppjKGbnR3hnpVapd7BNSR4vGel9Hhgnbkxd31EnxOocfYVH
         azkHlSwAVFv8iu8oIjurZBCIHunDtwzCeLyotVJ3Czc731qbBg8SMQsQjQ2kMPHrj7M0
         EVZlsp8f6Nmx0m8y7xacS61erLZRdQ/8Ub5nc=
MIME-Version: 1.0
Date: Wed, 2 Sep 2009 18:15:50 +0530
Message-ID: <f1c9d250909020545x90c3610nb75c0716cdf4d440@mail.gmail.com>
Subject: [BUG-rc8]: Kernel bootprocess
From: Tej <bewith.tej@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All,

Recently upgraded to 2.6.3-rc8. While doing I could not able to boot,
and boot process stop at dmesg saying something:
ADDR_CONF (NETDEV CHANGE): eth0 interface become ready.

message seems success only but affter pressing alt+ctl+del. machine
boot without xserver and complete / with readonly filesystem. So I
couldn't capture whole dmesg.

Now: I have bisected the problem (twice), and bisect result goes to
0db501bd0610ee0c0aca84d927f90bcccd09e2bd is first bad commit
commit 0db501bd0610ee0c0aca84d927f90bcccd09e2bd
Author: Eric W. Biederman <ebiederm@xmission.com>
Date:   Thu Aug 27 03:20:04 2009 -0700

    inotify: Ensure we alwasy write the terminating NULL.


lspci:
00:00.0 Host bridge: Intel Corporation 82945G/GZ/P/PL Memory
Controller Hub (rev 02)
00:02.0 VGA compatible controller: Intel Corporation 82945G/GZ
Integrated Graphics Controller (rev 02)
00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High
Definition Audio Controller (rev 01)
00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI Controller #1 (rev 01)
00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI Controller #2 (rev 01)
00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI Controller #3 (rev 01)
00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI Controller #4 (rev 01)
00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2
EHCI Controller (rev 01)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev e1)
00:1f.0 ISA bridge: Intel Corporation 82801GB/GR (ICH7 Family) LPC
Interface Bridge (rev 01)
00:1f.2 IDE interface: Intel Corporation 82801GB/GR/GH (ICH7 Family)
SATA IDE Controller (rev 01)
00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 01)
01:05.0 Ethernet controller: Marvell Technology Group Ltd. 88E8001
Gigabit Ethernet Controller (rev 13)
