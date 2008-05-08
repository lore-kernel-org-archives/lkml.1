Return-Path: <linux-kernel-owner+w=401wt.eu-S1757914AbYEHI6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914AbYEHI6Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 04:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754203AbYEHI6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 04:58:14 -0400
Received: from n1.cetrtapot.si ([89.212.80.162]:50833 "EHLO n1.cetrtapot.si"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176AbYEHI6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 04:58:13 -0400
X-Greylist: delayed 1893 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 May 2008 04:58:13 EDT
Message-ID: <4822B919.5070707@cetrtapot.si>
Date: Thu, 08 May 2008 10:26:01 +0200
From: =?UTF-8?B?SGlua28gS2/EjWV2YXI=?= <hinko.kocevar@cetrtapot.si>
User-Agent: Thunderbird 2.0.0.12 (X11/20080421)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: time stamped printks
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm building latest GIT tree kernel for CRIS architecture. Right now I'm seeing 
some strange values with printk stamps - at the start they are initialized to 0, 
but quickly change to 42949372 - 0x028F5AFC.

Any thoughts to where to look for fix?


[    0.000000] Linux version 2.6.26-rc1-cris-00180-g21a1022 
(hinkok@alala.kranj.cetrtapot.si) (gcc version 3.2.1 Axis release R64/1.64) #12 
Thu May 8 10:09:47 CEST 2008
[    0.000000] console [ttyS0] enabled
[    0.000000] Setting up paging and the MMU.
[    0.000000] Linux/CRIS port on ETRAX 100LX (c) 2001 Axis Communications AB
[42949372.961619] Built 1 zonelists in Zone order, mobility grouping on.  Total 
pages: 2040
[42949372.961714] Kernel command line: root=/dev/nfs rw ip=dhcp init=/linuxrc 
console=ttyS0,38400
[42949372.963114] PID hash table entries: 64 (order: 6, 256 bytes)
[42949372.963450] ds1302: RTC found.
[42949372.963557] ds1302: SDA, SCL, RST on PB0, PB1, GENIO0
[42949372.963744] rtc_time	: 08:23:41
[42949372.963768] rtc_date	: 2008-05-08
[42949372.963744] Dentry cache hash table entries: 2048 (order: 0, 8192 bytes)

Best regards,
Hinko

-- 
ČETRTA POT, d.o.o., Kranj
Planina 3
4000 Kranj
Slovenia, Europe
Tel. +386 (0) 4 280 66 03
E-mail: hinko.kocevar@cetrtapot.si
Http: www.cetrtapot.si

