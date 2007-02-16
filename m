Return-Path: <linux-kernel-owner+w=401wt.eu-S1423091AbXBPDf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423091AbXBPDf3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 22:35:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423093AbXBPDf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 22:35:29 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:57776 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423091AbXBPDf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 22:35:28 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] shm:  Fix the locking and cleanup error handling in do_shmat.
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
	<45D47020.1010309@googlemail.com>
	<20070215140232.0aba86a7.akpm@linux-foundation.org>
	<45D4EBB3.2060800@googlemail.com>
	<m1r6srhsrt.fsf_-_@ebiederm.dsl.xmission.com>
	<45D4F91F.505@googlemail.com>
Date: Thu, 15 Feb 2007 20:34:55 -0700
In-Reply-To: <45D4F91F.505@googlemail.com> (Michal Piotrowski's message of
	"Fri, 16 Feb 2007 01:21:51 +0100")
Message-ID: <m18xeyixls.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> drivers/video/Kconfig:1606:warning: 'select' used by config symbol 'FB_PS3'
> refer to undefined symbol 'PS3_PS3AV'
> /mnt/md0/devel/linux-mm/ipc/shm.c: In function 'do_shmat':
> /mnt/md0/devel/linux-mm/ipc/shm.c:945: warning: passing argument 1 of 'IS_ERR'
> makes pointer from integer without a cast
> /mnt/md0/devel/linux-mm/ipc/shm.c:946: warning: passing argument 1 of 'PTR_ERR'
> makes pointer from integer without a cast
> /mnt/md0/devel/linux-mm/ipc/shm.c:931: warning: label 'out_nattch' defined but
> not used
> /mnt/md0/devel/linux-mm/ipc/shm.c:890: error: label 'out_put_path' used but not
> defined
> make[2]: *** [ipc/shm.o] Error 1
> make[1]: *** [ipc] Error 2
> make: *** [_all] Error 2

Definitely some weird  patch application problem.

All of the calls to IS_ERR and PTR_ERR should have been removed.
Michal since it didn't seem to blow up when Andrew applied it I'm
going to assume the problem is on your end for now.

Eric


