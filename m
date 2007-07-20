Return-Path: <linux-kernel-owner+w=401wt.eu-S933438AbXGTPCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933438AbXGTPCY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 11:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764602AbXGTPCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 11:02:18 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:12728 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762759AbXGTPCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 11:02:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=EN4O/u8sR3N3fP4mx6py1bSZTETQ09C3oHk2oUnPTXsPebVHP6TTYmnCs0mEgqDIcsPPbQBcE9LkdtRr51XX+u4O3sEuXO68kG/eoHreXdKV9Bn6subqw34wyztXYdg7u220i6tGJm87aPlyq2k5B7fQ59bVu8FK75xtNUeKH5k=
Message-ID: <6bffcb0e0707200802h262af4f7q48e35e3a7f732a4a@mail.gmail.com>
Date: Fri, 20 Jul 2007 17:02:13 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "David Chinner" <dgc@sgi.com>
Subject: [broken-out-2007-07-20-00-22] XFS build error
Cc: xfs-masters@oss.sgi.com, "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

I get this build error on the latest -mm snapshot

fs/xfs/linux-2.6/xfs_file.c:483: error: unknown field 'populate'
specified in initializer
fs/xfs/linux-2.6/xfs_file.c:483: error: 'filemap_populate' undeclared
here (not in a function)
fs/xfs/linux-2.6/xfs_file.c:483: warning: excess elements in struct initializer
fs/xfs/linux-2.6/xfs_file.c:483: warning: (near initialization for
'xfs_file_vm_ops')
make[2]: *** [fs/xfs/linux-2.6/xfs_file.o] Error 1
make[1]: *** [fs/xfs] Error 2
make: *** [fs] Error 2

quilt patches fs/xfs/linux-2.6/xfs_file.c
patches/git-xfs.patch
patches/git-xfs-fixup.patch

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
