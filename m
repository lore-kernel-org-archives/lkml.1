Return-Path: <linux-kernel-owner+w=401wt.eu-S1755114AbXITMgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114AbXITMgo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 08:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbXITMgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 08:36:36 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46364 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbXITMgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 08:36:36 -0400
Date: Thu, 20 Sep 2007 18:09:28 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Leonid Kalev <lion@3tera.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, dushistov@mail.ru
Subject: Re: [PATCH] [UFS] fs/ufs/super.c misreads the file system state
In-Reply-To: <46F14EF3.3050606@3tera.com>
Message-ID: <alpine.LFD.0.999.0709201804050.17093@enigma.security.iitk.ac.in>
References: <46F14EF3.3050606@3tera.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 19 Sep 2007, Leonid Kalev wrote:
> 
> ufs_get_fs_state() needs the file system type to read the state from the
> correct place in the superblock. It takes the type from UFS_SB(sb)->s_flags,
> but that value is stored after the first call to ufs_get_fs_state(). The patch
> below moves the assignment of s_flags up, before the first call to
> ufs_get_fs_state().
> 
> The patch is against linux-2.6.23-rc6-git7, but it applies (with offset) to
> 2.6.22 and to earlier versions as well. It has been tested on the Solaris
> flavor of UFS (ufstype=sunx86) - with this change, the file system can be used
> in read-write mode.

The same fix is already in 2.6.23-rc6-mm1 (don't know if it's lined up
for .23 though, I think it should be).


Satyam

PS: All my mails to Evgeniy Dushistov never reach him. The mail.ru server
    is absolutely *evil* and simply rejects all mails unless the sender
    is already whitelisted by the reciever (!)
