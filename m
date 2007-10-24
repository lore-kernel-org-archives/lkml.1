Return-Path: <linux-kernel-owner+w=401wt.eu-S1754814AbXJXDby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbXJXDby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 23:31:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbXJXDbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 23:31:43 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:33207 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbXJXDbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 23:31:42 -0400
Message-ID: <471EBC02.5000907@linux.vnet.ibm.com>
Date: Wed, 24 Oct 2007 08:59:06 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: linux390@de.ibm.com
CC: linux-s390@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
Subject: [BUG] 2.6.23-git19 - S390x: Kernel panic while bringing up the network
 interface
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Kernel panic's while bringing up the network interface with the 2.6.23-git19

Setting network parameters:  Ý  OK  ¨
Bringing up loopback interface:  Ý  OK  ¨
Bringing up interface eth0:
 Ý<00000000002e2f72>¨ inet_ioctl+0xd6/0x110
 Ý<000000000027cae2>¨ sock_ioctl+0x26e/0x2a0
 Ý<00000000000b4c52>¨ do_ioctl+0x4a/0xac
 Ý<00000000000b5076>¨ vfs_ioctl+0x3c2/0x3d8
 Ý<00000000000b50ec>¨ sys_ioctl+0x60/0x88
 Ý<0000000000021b7e>¨ sysc_noemu+0x10/0x16
 Ý<00000200001201ca>¨ 0x200001201ca

 <0>Kernel panic - not syncing: Fatal exception in interrupt
00: HCPGSP2629I The virtual machine is placed in CP mode due to a SIGP stop from
 CPU 01.
02: HCPGSP2629I The virtual machine is placed in CP mode due to a SIGP stop from
 CPU 01.
03: HCPGSP2629I The virtual machine is placed in CP mode due to a SIGP stop from
 CPU 01.
01: HCPGIR450W CP entered; disabled wait PSW 00020001 80000000 00000000 000164DE

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
