Return-Path: <linux-kernel-owner+w=401wt.eu-S1755305AbXGWOjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbXGWOjd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 10:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755560AbXGWOjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 10:39:14 -0400
Received: from smtp2f.orange.fr ([80.12.242.151]:60198 "EHLO smtp2f.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755442AbXGWOjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 10:39:13 -0400
X-Greylist: delayed 6502 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Jul 2007 10:39:13 EDT
X-ME-UUID: 20070723125048603.935327000095@mwinf2f21.orange.fr
From: "werner" <werner@copaya.yi.org>
Subject: Problems with kernel 2.6.22-git15, 2.6.23-rc1
To: linux-kernel@vger.kernel.org
X-Originating-IP: 81.248.34.63
X-Mailer: Usermin 1.270
Message-Id: <1185194404.4519@werner>
Date: Mon, 23 Jul 2007 09:40:04 -0300 (GFT)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bound1185194404"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--bound1185194404
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit

There are incompatibilities in kmem_cache_create , which makes that a lot of important progs dont compile longer -- such as ndiskwrapper , btrfs (in this file system, me and other people storage important data) and others.   Also obexfs/bluetooth seems to dont work more correctly, however by other incompatibility

This is since 2.6.22-git15 and on 2.6.23-rc1 , too

The kernel need to stay compatible to old versions of the file system and other fundamental programs.

Please correct this   


Werner Landgraf

www.copaya.yi.org

============ Example: ======================

/usr/local/src/btrfs-0.2/inode.c: In function 'btrfs_init_cachep':
/usr/local/src/btrfs-0.2/inode.c:1941: error: too many arguments to function 'kmem_cache_createmake[1]: Leaving directory `/usr/src/linux-2.6.23-rc1-i486-1mn'
ts to function 'kmem_cache_create'
/usr/local/src/btrfs-0.2/inode.c:1955: error: too many arguments to function 'kmem_cache_create'
/usr/local/src/btrfs-0.2/inode.c:1962: error: too many arguments to function 'kmem_cache_create'
/usr/local/src/btrfs-0.2/inode.c:1970: error: too many arguments to function 'kmem_cache_create'
make[2]: *** [/usr/local/src/btrfs-0.2/inode.o] Error 1
make[1]: *** [_module_/usr/local/src/btrfs-0.2] Error 2
make: *** [all] Error 2


--bound1185194404--


