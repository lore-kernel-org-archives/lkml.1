Return-Path: <linux-kernel-owner+w=401wt.eu-S1762750AbYCGWcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762750AbYCGWcv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 17:32:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757614AbYCGWcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 17:32:42 -0500
Received: from ns2.g-housing.de ([81.169.133.75]:37715 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757551AbYCGWcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 17:32:41 -0500
Date: Fri, 7 Mar 2008 23:32:37 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: devzero@web.de
cc: ingo@elte.hu, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2.6.24] chroot= as a new kernel parameter
In-Reply-To: <187865500@web.de>
Message-ID: <alpine.DEB.1.00.0803072330080.7723@sheep.housecafe.de>
References: <187865500@web.de>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Mar 2008, devzero@web.de wrote:

>> * H. Peter Anvin <hpa@zytor.com> wrote:
>>>       init=/path/to/any/sbin/chroot /newroot /sbin/init

Great, I was looking for something like this myself some time ago!

> wouldn`t it be useful to add a hint to kernel-parameters.txt ?

How about:

--- linux-2.6-git/Documentation/kernel-parameters.txt	2008-02-21 12:01:37.000000000 +0100
+++ linux-2.6-git/Documentation/kernel-parameters.txt.edited	2008-03-07 23:26:39.000000000 +0100
@@ -799,9 +799,12 @@ and is between 256 and 4096 characters.
  			See header of drivers/scsi/in2000.c.

  	init=		[KNL]
-			Format: <full_path>
+			Format: <full_path> <options>
  			Run specified binary instead of /sbin/init as init
-			process.
+			process. init= is able to take more than one option
+			allowing us to do:
+			init=/path/to/any/sbin/chroot /newroot /sbin/init
+			...and thus booting into /newroot.

  	initcall_debug	[KNL] Trace initcalls as they are executed.  Useful
  			for working out where the kernel is dying during

Thanks,
Christian.
-- 
BOFH excuse #116:

the real ttys became pseudo ttys and vice-versa.
