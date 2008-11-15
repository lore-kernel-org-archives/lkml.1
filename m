Return-Path: <linux-kernel-owner+w=401wt.eu-S1755829AbYKOPPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829AbYKOPPo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 10:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbYKOPPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 10:15:34 -0500
Received: from buick.jordet.net ([193.91.240.190]:54063 "EHLO buick.jordet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426AbYKOPPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 10:15:33 -0500
X-Greylist: delayed 1874 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Nov 2008 10:15:32 EST
Subject: Slowness with new pc
From: Stian Jordet <liste@jordet.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Sat, 15 Nov 2008 15:44:14 +0100
Message-Id: <1226760254.5089.11.camel@chevrolet>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

This fall I built myself a new computer. It's a dual cpu quad core xeon
(E5405) on a Supermicro X7DWA-N motherboard. It has 8GB 800mhz ram, and
a Supermicro AOC-USAS-S8iR RAID SAS controller, with a pair of Fujitsu
MBA3073RC disks in raid 0. Should be pretty fast, but it isn't. In daily
use it feels just about the same as my old Dual P3 1ghz with a single
SCSI disk. Has to wait a couple of seconds before the gnome menu appears
after I've clicked on it, for instance. But with operations involving
heavy disk use, it's extremely slow! For instance, unpacking the bzipped
2.6.27.6 kernel takes 6:40 minutes, while compiling it takes a mere
5:13. I thought I had a hardware problem (still not ruling that out), so
I tried to install Vista, and then everything was blazingly fast. I have
no clue where to look, but a static benchmark like hdparm gives me a
throughput of 235MB/s on the raid 0 array. Could it be
filesystem-related? I'm using XFS (always have)... 

Please cc me on any replies.

Regards,
Stian

