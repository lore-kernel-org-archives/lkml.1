Return-Path: <linux-kernel-owner+w=401wt.eu-S1754117AbXDVHI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbXDVHI2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 03:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754120AbXDVHI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 03:08:28 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:57998 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107AbXDVHI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 03:08:27 -0400
To: ebiederm@xmission.com
CC: miklos@szeredi.hu, akpm@linux-foundation.org, serue@us.ibm.com,
       viro@ftp.linux.org.uk, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
In-reply-to: <m1slatkg8g.fsf@ebiederm.dsl.xmission.com>
Subject: Re: [patch 2/8] allow unprivileged umount
References: <20070420102532.385211890@szeredi.hu>
	<20070420102626.825263599@szeredi.hu> <m1slatkg8g.fsf@ebiederm.dsl.xmission.com>
Message-Id: <E1HfW90-00045g-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sun, 22 Apr 2007 09:05:58 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>   I suspect we can allow MNT_FORCE for non-privileged users 
>   as well if we can trust the filesystem.

I don't think so.  MNT_FORCE has side effects on the superblock.  So a
user shouldn't be able to force an unmount on a bind mount s/he did,
but there's no problem with allowing plain/lazy unmounts.

We could possibly allow MNT_FORCE, for FS_SAFE filesystems.

Miklos
