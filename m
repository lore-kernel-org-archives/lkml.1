Return-Path: <linux-kernel-owner+w=401wt.eu-S1756666AbZEZRMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbZEZRMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 13:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754357AbZEZRMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 13:12:03 -0400
Received: from mailhost-l1-m1.netultra.net ([78.40.49.174]:61601 "EHLO
	smtp-delay2.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753978AbZEZRMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 13:12:02 -0400
Date: Tue, 26 May 2009 19:10:58 +0200
From: Damien Wyart <damien.wyart@free.fr>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk
Subject: Re: [PATCH 0/12] Per-bdi writeback flusher threads v7
Message-ID: <20090526171058.GA3314@localhost.localdomain>
References: <1243330430-9964-1-git-send-email-jens.axboe@oracle.com>
 <20090526152501.GA20968@localhost.localdomain>
 <20090526164117.GJ11363@kernel.dk>
 <20090526170845.GA3226@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090526170845.GA3226@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-05-25)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also note that on both systems, / is ext3, other mountpoints are xfs and
I also have one or two vfat FS mounted. Here is the corresponding fstab:

proc            /proc           proc     defaults                                       0       0
/dev/sdb8       none            swap     sw                                             0       0
/dev/sdb2       /               ext3 defaults,data=writeback,errors=remount-ro,relatime 0       1
tmpfs           /tmp            tmpfs defaults,nosuid,nodev,size=1G                     0       0
/tmp            /var/tmp        none     bind                                           0       0
/dev/sdb5       /usr            xfs      defaults,noatime,nodiratime                    0       2
/dev/sdb6       /home           xfs      defaults,noatime,nodiratime                    0       2
/dev/sdb7       /storage1       xfs      defaults,noatime,nodiratime                    0       2
/dev/sda5       /storage2       xfs      defaults,noatime,nodiratime                    0       2
/dev/sdb9       /storage3       xfs      defaults,noatime,nodiratime                    0       2
#
/dev/sdb1       /storagewin     vfat defaults,uid=dw,gid=dw,showexec,quiet              0       0

-- 
Damien Wyart
