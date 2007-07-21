Return-Path: <linux-kernel-owner+w=401wt.eu-S938961AbXGUPCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938961AbXGUPCb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 11:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761185AbXGUPCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 11:02:23 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:37344 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759272AbXGUPCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 11:02:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=FgDqiuuKqfpE6XyAXLuarR1pw16LtEspZa/ZAdpnnVbKFzDiPzte2ipGO/e1vmYkkthi2bJgoE1GTTRHC4JU/athGtrg75TGL3p8A2md/LHEWd0tRJeQpct7qJ2OMq3hfTrvETMWqW6FoKaZfMmhuwlXaDlelSCAxpwPzsYgiW0=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [00/37] Clean up duplicate includes
Date: Sat, 21 Jul 2007 17:01:23 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707211701.23911.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

This is a series of patches to clean up the vast majority of 
duplicate includes in the source tree. There are still a few
offenders left after these patches, but this takes care of 
the vast majority.

I've split the patches by directory in the hope that each 
patch will then hit the area of responsability of a single 
person, or at most a few.
I've tried to Cc the appropriate people and mailing lists for 
each patch, but without a doubt I'll have sent some of the 
patches to the wrong people and omitted some people that 
should have been on the Cc list. I hope that if someone 
doesn't get a patch directly, they can still notice it from this 
mail and pick it up from LKML (or just ask me to send it).


These are the patches in this series : 

 [PATCH][01/37] Clean up duplicate includes in Documentation/
 [PATCH][02/37] Clean up duplicate includes in arch/i386/kernel/
 [PATCH][03/37] Clean up duplicate includes in arch/i386/xen/
 [PATCH][04/37] Clean up duplicate includes in drivers/atm/
 [PATCH][05/37] Clean up duplicate includes in drivers/block/
 [PATCH][06/37] Clean up duplicate includes in drivers/char/
 [PATCH][07/37] Clean up duplicate includes in drivers/hwmon/
 [PATCH][08/37] Clean up duplicate includes in drivers/input/
 [PATCH][09/37] Clean up duplicate includes in drivers/macintosh/
 [PATCH][10/37] Clean up duplicate includes in drivers/media/
 [PATCH][11/37] Clean up duplicate includes in drivers/mtd/
 [PATCH][12/37] Clean up duplicate includes in drivers/net/
 [PATCH][13/37] Clean up duplicate includes in drivers/scsi/
 [PATCH][14/37] Clean up duplicate includes in drivers/spi/
 [PATCH][15/37] Clean up duplicate includes in drivers/usb/
 [PATCH][16/37] Clean up duplicate includes in drivers/w1/
 [PATCH][17/37] Clean up duplicate includes in fs/
 [PATCH][18/37] Clean up duplicate includes in fs/ecryptfs/
 [PATCH][19/37] Clean up duplicate includes in fs/gfs2/
 [PATCH][20/37] Clean up duplicate includes in fs/ntfs/
 [PATCH][21/37] Clean up duplicate includes in include/media/
 [PATCH][22/37] Clean up duplicate includes in include/linux/memory_hotplug.h
 [PATCH][23/37] Clean up duplicate includes in include/linux/nfs_fs.h
 [PATCH][24/37] Clean up duplicate includes in kernel/
 [PATCH][25/37] Clean up duplicate includes in mm/
 [PATCH][26/37] Clean up duplicate includes in net/atm/
 [PATCH][27/37] Clean up duplicate includes in net/bridge/
 [PATCH][28/37] Clean up duplicate includes in net/ipv4/
 [PATCH][29/37] Clean up duplicate includes in net/ipv6/
 [PATCH][30/37] Clean up duplicate includes in net/netfilter/
 [PATCH][31/37] Clean up duplicate includes in net/sched/
 [PATCH][32/37] Clean up duplicate includes in net/sunrpc/
 [PATCH][33/37] Clean up duplicate includes in net/tipc/
 [PATCH][34/37] Clean up duplicate includes in net/xfrm/
 [PATCH][35/37] Clean up duplicate includes in sound/core/
 [PATCH][36/37] Clean up duplicate includes in sound/ppc/
 [PATCH][37/37] Clean up duplicate includes in sound/soc/


Please consider applying these patches.


Kind regards,
 Jesper Juhl <jesper.juhl@gmail.com>


