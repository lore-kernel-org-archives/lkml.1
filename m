Return-Path: <linux-kernel-owner+w=401wt.eu-S933004AbXBQV3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004AbXBQV3u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 16:29:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932993AbXBQV3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 16:29:47 -0500
Received: from noname.neutralserver.com ([70.84.186.210]:45547 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932990AbXBQV3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 16:29:46 -0500
Date: Sat, 17 Feb 2007 23:29:19 +0200
From: Dan Aloni <da-x@monatomic.org>
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Cc: Lew Glendenning <lglendenning@lnxi.com>
Subject: e2b2rom_init_one():  Unable to register resource
Message-ID: <20070217212918.GA26554@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-PopBeforeSMTPSenders: da-x@monatomic.org
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - noname.neutralserver.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - monatomic.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm running the x86_64 arch of Linux 2.6.20 on a Supermicro X6DH8-XG2 
board and I got this during boot:

[248660.950695] device id = 2440
[248660.950699] device id = 2480
[248660.950703] device id = 24c0
[248660.950706] device id = 24d0
[248660.950709] matched device = 24d0
[248660.950712] matched device id 24d0
[248660.950716] pci_read_config_byte : 4
[248660.950723] esb2rom: esb2rom_init_one(): Unable to register resource 
0xffffffffffc00000-0xffffffff - kernel bug?
[248660.950729] esb2rom: ioremap(ffffffffffc00000, 100400000) failed
[248660.956859] retVal = -19

Looks like some kind of a 64-bit portability bug...

-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
