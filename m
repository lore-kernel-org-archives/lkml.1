Return-Path: <linux-kernel-owner+w=401wt.eu-S932863AbZJHS3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932863AbZJHS3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 14:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932703AbZJHS33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 14:29:29 -0400
Received: from server.logic.univie.ac.at ([131.130.191.2]:52433 "EHLO
	server.logic.univie.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932693AbZJHS33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 14:29:29 -0400
X-Greylist: delayed 1753 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Oct 2009 14:29:29 EDT
Date: Thu, 8 Oct 2009 19:59:39 +0200
To: linux-kernel@vger.kernel.org
Subject: Allocated Mem - 700MB missing
Message-ID: <20091008175939.GA31126@logic.univie.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Andreas <andreas2@logic.univie.ac.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi experts!

Where are the missing 700MB ???		(4GB installed)
700 MB is too much, that can't be only because of version-differences!

I compared (unmodified) stable/testing kernels with Xen and OpenVZ-kernel:
all out of main debian packages:

Only3200:
----------
*Linux host 2.6.18-5-686 #1 SMP Mon Dec 24 16:41:07 UTC 2007 i686 GNU/Linux
*Linux knoppix 2.6.24.4 #2 SMP PREEMPT Tue Mar 25 21:35:28 CET 2008 i686 GNU/Linux
*Linux host 2.6.26-2-686 #1 SMP Sun Jun 21 04:57:38 UTC 2009 i686 GNU/Linux


Full4GB:
---------
*Linux host 2.6.26-2-openvz-686 #1 SMP Sun Jun 21 07:07:25 UTC 2009 i686 GNU/Linux

I'm using:
Dell Optiplex 755
Board Product name (DMI): 0GM819
2x2GB (4064MB) installed


Here the output of free:

#mem: Only3200free:
             total       used       free     shared    buffers     cached
Mem:       3358232      30760    3327472          0       1668      13608
-/+ buffers/cache:      15484    3342748
Swap:            0          0          0

#memOnly3200freeXenDom0.txt:
             total       used       free     shared    buffers     cached
Mem:       3873216     136068    3737148          0       1024      12852
-/+ buffers/cache:     122192    3751024
Swap:            0          0          0

#memOnly3900free-2.6.30.1-amd64.txt:
             total       used       free     shared    buffers     cached
Mem:       3920696     606612    3314084          0      14608     251372
-/+ buffers/cache:     340632    3580064
Swap:      7831676          0    7831676

#memFull4GBfree-OpenVZ (Dom0):
             total       used       free     shared    buffers     cached
Mem:       4003584     451420    3552164          0       8132     143652
-/+ buffers/cache:     299636    3703948
Swap:            0          0          0

I attached the output of dmesg and proc/meminfo of 
the normal kernel (only 3200M) and openVZ-kernel (gives full 4GBs)
XenDom0 gives 3900, which is ok.

i*)Question2:
Do I have better performance, if installed to DIMM1+3 (next to each other) 
 => Bios says: asynchronous, 
  or DIMM1+2 (3 inbetween them left out) => Bios says: synchronous ?


Please be so kind and also send your answer to andreas2 (AT)
 logic.univie.ac.at        (I didn't subscribe to the group) 


thanks!
Andrew

