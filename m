Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab0BOFOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 00:14:18 -0500
Received: from troy.hostgo.com ([64.62.143.130]:57288 "EHLO troy.hostgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770Ab0BOFOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 00:14:17 -0500
X-Greylist: delayed 668 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Feb 2010 00:14:17 EST
From: Thomas Fjellstrom <tfjellstrom@strangesoft.net>
To: linux-kernel@vger.kernel.org
Subject: missing rtl8168d-1.fw causing 2 minute boot delay
Date: Sun, 14 Feb 2010 22:14:13 -0700
User-Agent: KMail/1.12.4 (Linux/2.6.32-trunk-amd64; KDE/4.3.4; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002142214.13818.tfjellstrom@strangesoft.net>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - troy.hostgo.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - strangesoft.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm having problems with my home server. Basically it stalls for two minutes 
looking for a firmware file that doesn't seem to exist anywhere on the 
internet. just references on the debian mailing lists saying they don't have 
permission to distribute the firmware.

[   66.376056] eth0: unable to apply firmware patch                                                                                                              
[   67.180794] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded                                                                                                   
[   67.182785] r8169 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 
17                                                                                    
[   67.184928] r8169 0000:03:00.0: setting latency timer to 64                                                                                                   
[   67.184958]   alloc irq_desc for 30 on node 0                                                                                                                 
[   67.184960]   alloc kstat_irqs on node 0                                                                                                                      
[   67.184970] r8169 0000:03:00.0: irq 30 for MSI/MSI-X                                                                                                          
[   67.185464] eth1: RTL8168d/8111d at 0xffffc90000656000, 
00:24:1d:18:f8:f3, XID 081000c0 IRQ 30                                                                
[   67.194306] r8169 0000:03:00.0: firmware: requesting rtl8168d-1.fw                                                                                            
[  127.196044] eth1: unable to apply firmware patch      

It's obviously non-fatal, but its also very annoying. Is there a way I can 
get rid of this 2 minute delay?

-- 
Thomas Fjellstrom
tfjellstrom@strangesoft.net
