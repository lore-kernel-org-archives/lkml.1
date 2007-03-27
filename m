Return-Path: <linux-kernel-owner+w=401wt.eu-S965397AbXC0UeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965397AbXC0UeY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 16:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965404AbXC0UeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 16:34:24 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:61431 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965397AbXC0UeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 16:34:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=VtYg30MO0DkFNIL+EzXKaVqG8Zxp04/c+HAidqW395o+Lrs41O7BMA7uwVPBiKBALxKM19A9EcKn6D64yxsCVLitVwd+LUl3qZNyxDm2/wAC06UBTZ2WHa1UbKtaCQDb/hRPLe5NDf+JUvmi5jfpEzaxFoXuB54RzO7Go7NGrGw=
Message-ID: <2fe399760703271334j1fe56c9ctc83e1310620d7728@mail.gmail.com>
Date: Tue, 27 Mar 2007 13:34:21 -0700
From: "Phy Prabab" <phyprabab@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Issues with knfsd + solaris clients
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello once again!

Here is a little bit more information on my issue with slowlaris and
knfs 2.6.21-rc4/5 (actually appears in 2.4.20.x).  Running this from
the client (x.org source code):
> ls -l xc/lib/Xmu/Xct.h
-rw-rw-r-- 1 phy bdf 0 2006-01-09 06:59 xc/lib/Xmu/Xct.h
> file xc/lib/Xmu/Xct.h
xc/lib/Xmu/Xct.h:       cannot read: Is a directory
> rm -rf xc/lib/Xmu/Xct.h
rm: cannot remove `xc/lib/Xmu/Xct.h': Not owner
> uname -a
SunOS mm3 5.10 Generic_118855-14 i86pc i386 i86pc Solaris
>chmod 777 xc/lib/Xmu/Xct.h
> rm -rf xc/lib/Xmu/Xct.h
rm: cannot remove `xc/lib/Xmu/Xct.h': Not owner
>

I would think the file would not be directory and if I tried to remove
it, I should be able as owner and permissions are correct.  This is on
a solaris 10 on intel, but I also see this problem on solaris 8, 9 and
10 on sparc.  Again, AIX5303 and 04 and all linux clients (2.4.x,
2.6.x) seem to be fine.

The file server is a dual dual core Opteron running 2.6.21-rc4+5 (but
also see this problem with 2.6.20.x), knfsd, XFS file system on LVM2
partition, on a 3Ware 9650 14 disk RAID 10.  Using nfs-1.0.12 and
LVM2.0.22 (?).

Also posting to LKML.

Any help is greatly appreciated.
TIA,
Phy

----- Original Message ----
From: Phy Prabab <phyprabab@yahoo.com>
To: nfs@lists.sourceforge.net
Sent: Tuesday, March 27, 2007 12:32:16 PM
Subject: Issues with 2.6.21-rc4/5 and slowlaris 8

Hello,

I am having some issues with slowlaris 8 sparc and linux 2.6.21-rc4/5
(actually, 2.6.20.x as well) with directory permissions.  The client
is the slowlaris box mounting a file system (XFS, LVM, DM, 3Ware 9650)
from the linux box.  I extract some files from a tar ball and then try
to delete them, I get permission denied, however, the files are owned
by my uid and the file permissions are 775.  Any help figuring this
out would be most welcome.  I can provide plenty of debugging if
needed.

TIA!
Phy
