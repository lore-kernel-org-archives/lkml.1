Return-Path: <linux-kernel-owner+w=401wt.eu-S1755128AbXDZVXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128AbXDZVXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 17:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755133AbXDZVXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 17:23:20 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:51430 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128AbXDZVXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 17:23:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=J8bMNC6ofM8cRuL56CevzREDNwgFkXd4CFu2Arr0ybeTDzS6krikALpEWFQ8cYL+3hgTyMeLmFv1Y54XBzcPC63+U63xEDzQ98QtZF4xb1OVameVlkmD3dMxjbEuTuu03wj5KpM5Dy/9K4i5W5Jfhj2ZNG9a6LPDwHyNnYXGdcg=
Message-ID: <463117DF.2020103@googlemail.com>
Date: Thu, 26 Apr 2007 23:21:35 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm snapshot broken-out-2007-04-25-02-49.tar.gz uploaded
References: <200704250952.l3P9qIHh032233@shell0.pdx.osdl.net> <462FB8E6.9070501@googlemail.com>
In-Reply-To: <462FB8E6.9070501@googlemail.com>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Michal Piotrowski napisa³(a):
> Hi all,
> 
> akpm@linux-foundation.org napisa³(a):
>> The mm snapshot broken-out-2007-04-25-02-49.tar.gz has been uploaded to
>>
>>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-04-25-02-49.tar.gz
>>
>> It contains the following patches against 2.6.21-rc7:
>>
> 
> My network doesn't work
> 
> $ ping 192.168.0.1
> connect: Network is unreachable
> 
> NIC: 
> 02:05.0 Ethernet controller: 3Com Corporation 3c940 10/100/1000Base-T [Marvell] (rev 12)
> 
> quilt patches drivers/net/skge.c
> patches/git-netdev-all.patch
> patches/git-net.patch
> 
> Bisection...
> 

I tracked this problem down to your patches (kernel 2.6.21-rc7-mm2)

gregkh-driver-sysfs-fix-i_ino-handling-in-sysfs.patch
gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
gregkh-driver-sysfs-move-release_sysfs_dirent-to-dirc.patch
gregkh-driver-sysfs-flatten-cleanup-paths-in-sysfs_add_link-and-create_dir.patch
gregkh-driver-sysfs-consolidate-sysfs_dirent-creation-functions.patch
gregkh-driver-sysfs-add-sysfs_dirent-s_parent.patch
gregkh-driver-sysfs-add-sysfs_dirent-s_name.patch
gregkh-driver-sysfs-make-sysfs_dirent-s_element-a-union.patch
gregkh-driver-sysfs-implement-kobj_sysfs_assoc_lock.patch
gregkh-driver-sysfs-reimplement-symlink-using-sysfs_dirent-tree.patch
gregkh-driver-sysfs-implement-bin_buffer.patch
gregkh-driver-sysfs-implement-sysfs_dirent-active-reference-and-immediate-disconnect.patch
gregkh-driver-sysfs-kill-attribute-file-orphaning.patch
gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
gregkh-driver-sysfs-make-lockdep-ignore-s_active.patch
gregkh-driver-sysfs-make-sysfs_put-ignore-null-sd.patch
gregkh-driver-sysfs-rename-object_depth-to-sysfs_path_depth-and-make-it-global.patch
gregkh-driver-sysfs-reimplement-sysfs_drop_dentry.patch
gregkh-driver-sysfs-kill-sysfs_dirent-s_dentry.patch
gregkh-driver-driver-core-make-uevent-environment-available-in-uevent-file.patch

ABI breakage?

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-04-25-02-49/mm-config

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
