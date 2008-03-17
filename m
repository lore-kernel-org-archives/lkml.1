Return-Path: <linux-kernel-owner+w=401wt.eu-S1754406AbYCQOSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406AbYCQOSs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 10:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbYCQOSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 10:18:38 -0400
Received: from mail.daxal.com ([66.221.37.219]:33203 "EHLO mail.daxal.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431AbYCQOSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 10:18:38 -0400
From: "Scott Edwards" <lkml@foss.daxal.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Fibre channel network interfaces + Linux SAN
Date: Mon, 17 Mar 2008 09:18:36 -0500
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="utf-8,iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <20080317141836.29FB5320007@mail.daxal.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two things I'm trying to solve with my fc hardware.  How do I enable these 
for IP networking, and how do I offer say lvm logical volumes behind Linux 
as a SAN? I'd like nodes to be bootable and offer specific volumes as their 
disks.  I'm using 2.6.28 

As for networking, I vaguely remember setting up IPv4 on fibre channel some 
time ago.  So far I have two hosts connected to a Compaq Storage Works FC 
arbitrated loop.  Each host has Online for 
/sys/class/fc_host/hostN/port_state.  I can't find the network device in 
/proc/net/dev or via ifconfig -a. 

riddle: 2.6.18-5-xen-vserver-686
00:0a.0 Fibre Channel [0c04]: Emulex Corporation LP8000 Fibre Channel Host 
Adapter [10df:f800] (rev 02) 

armada: 2.6.18-5-vserver-686
01:0b.0 Fibre Channel [0c04]: Emulex Corporation LP8000 Fibre Channel Host 
Adapter [10df:f800] (rev 02) 

Both have lpfc loaded (if you didn't guess that by now).  I thought there 
was a more generic ip<->fc net driver. I did find net/802/fc.c using fc%d as 
the net device, and lpfc.ko is the only module I've found containing fc%d. 

modinfo lpfc seems to apply to the fc layer only.  I did find some outdated 
Emulex documentation about configuring this hardware for a network 
interface. 

Any comments? 

Thanks, 


Scott
 -- Daxal Communications - http://sslrenewal.com/?lkml 

