Return-Path: <linux-kernel-owner+w=401wt.eu-S1757183AbXKISzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183AbXKISzZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 13:55:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755105AbXKISzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 13:55:12 -0500
Received: from mailgw1.uni-kl.de ([131.246.120.220]:44115 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233AbXKISzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 13:55:10 -0500
X-Greylist: delayed 1324 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Nov 2007 13:55:09 EST
From: Bernd Strieder <strieder@informatik.uni-kl.de>
Organization: TU Kaiserlautern
To: linux-kernel@vger.kernel.org
Subject: x86_64 SATA DVD drive + libata trouble
Date: Fri, 9 Nov 2007 19:33:01 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711091933.01523.strieder@informatik.uni-kl.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

please CC me, I'm not subscribed.

If any kernel developer is interested in more specific information 
please mail me, I can build kernels, I can apply patches, though 
have not done it regularly.

I'd like to get the DVD drive working somehow. I have googled a lot 
and did not find any more ideas what to do. Some good keywords to 
find a solution would suffice at that end.

Rough problem description:

I have a Tyan mainboard with NVIDIA chipset CK804. The only 
SATA/IDE device is a SATA DVD combo, the harddisks are on a RAID 
controller from 3ware. The harddisks are fine.

The openSuSE 10.3 boot dvds fail after booting from the BIOS, the 
installation kernel cannot use the DVD drive. That kernel uses 
libata and sata_nv pata_amd as drivers. The drive is recognized 
but it cannot be used. This is the situation probably during 
install from DVD and now in the running system after a network 
install it persists.

Reading from the dvd device /dev/sr0 with dd stops after at most 
119kb of rubbish read. Mounting fails with superblock not found.
When trying to remove the pata_amd module I get an Oops. I tried to 
remove the modules to have a chance to reload them with other 
options (atapi_enable), but that did not help, even after 
rebooting.

A vanilla 2.6.23.1 kernel behaves even less friendly, the dd 
on /dev/sr0 causes a hard reset.

So there are clearly some problems with libata in this system.

I have failed switching away from libata getting the drive to be 
recognized at all.


Thanks for any help,

Bernd Strieder


