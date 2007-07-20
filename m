Return-Path: <linux-kernel-owner+w=401wt.eu-S941058AbXGTQKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941058AbXGTQKt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 12:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940785AbXGTQJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 12:09:56 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:42840 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S940777AbXGTQJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 12:09:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=tnHZn8X7O9YW/cM95YPdDfZaxiwadOdfqs9N17J+oLvba68QcX9wzJS22hw5mzZztbxrjhGNBLF+ct567bj6F9+D7KTqSA7peFj/PC2Lzb2YiRoQlSOBzDELpKlmNuEu9Ym9j6EHD/6neFbCOEVSemtAU6SIcCim31204qOGBj8=
Message-ID: <6bffcb0e0707200909i14b32b9cy23e5917fc3867796@mail.gmail.com>
Date: Fri, 20 Jul 2007 18:09:54 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Erez Zadok" <ezk@cs.sunysb.edu>
Subject: [broken-out-2007-07-20-00-22] unionfs build error
Cc: "Josef Jeff Sipek" <jsipek@cs.sunysb.edu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I get this error on the latest -mm snapshot

ERROR: "security_inode_permission" [fs/unionfs/unionfs.ko] undefined!
ERROR: "security_file_ioctl" [fs/unionfs/unionfs.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

CONFIG_UNION_FS=m
CONFIG_UNION_FS_XATTR=y

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
