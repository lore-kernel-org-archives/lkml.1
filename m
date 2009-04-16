Return-Path: <linux-kernel-owner+w=401wt.eu-S1758677AbZDPTYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758677AbZDPTYH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 15:24:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758052AbZDPTXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 15:23:53 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:58061 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757839AbZDPTXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 15:23:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=b0A4V4fv6o0H965G111QKm1pL2k4mAv94CGK9a+DqeOSSAcYkrvV481t1d7t4vLrHE
         zGiLRqcBRYnW0wZNtz0P7VurHbDuIHxmeNBzqmgifF1612VOsT4UDPIp6ZFdIpOgr+ZK
         O5XAYXb0foG8diQzWcqXbdMBorQ0i6iwcXYAM=
MIME-Version: 1.0
Date: Thu, 16 Apr 2009 23:23:50 +0400
Message-ID: <a4423d670904161223r2e026b6u903137c709318551@mail.gmail.com>
Subject: 2.6.30-rc2: reiserfs_delete_xattrs: Couldn't delete all xattrs (-13)
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Jeff Mahoney <jeffm@suse.com>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff

The kernel prints this message every 20seconds
[  836.973100]
[  836.983494] REISERFS warning (device sda2): jdm-20004
reiserfs_delete_xattrs: Couldn't delete all xattrs (-13)
[  836.983496]
[  894.203634] REISERFS warning (device sda2): jdm-20004
reiserfs_delete_xattrs: Couldn't delete all xattrs (-13)
[  894.203636]
[  894.205784] REISERFS warning (device sda2): jdm-20004
reiserfs_delete_xattrs: Couldn't delete all xattrs (-13)

commit a41f1a4715

CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
# CONFIG_REISERFS_FS_XATTR is not set

I did not enable XATTR before,
should I enable it now ?
