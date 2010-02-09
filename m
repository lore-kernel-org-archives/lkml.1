Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab0BIJIw (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 9 Feb 2010 04:08:52 -0500
Received: from fallback5.mail.ru ([94.100.176.59]:54490 "EHLO
	fallback5.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab0BIJIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 04:08:51 -0500
X-Greylist: delayed 536 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Feb 2010 04:08:50 EST
From: Evgeniy Dushistov <dushistov@mail.ru>
To: Alex Viskovatoff <viskovatoff@imap.cc>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: =?koi8-r?Q?Re=3A_[PATCH]_fs/ufs=3A_Recognize_Solaris-specific_file_system_state?=
Mime-Version: 1.0
X-Mailer: mPOP Web-Mail 2.19
X-Originating-IP: 192.168.2.49 via proxy [213.167.60.22]
Date: Tue, 09 Feb 2010 11:58:02 +0300
References: <1265683224.4096.1358983441@webmail.messagingengine.com>
In-Reply-To: <1265683224.4096.1358983441@webmail.messagingengine.com>
Reply-To: Evgeniy Dushistov <dushistov@mail.ru>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <E1Nelv0-0001bT-00.dushistov-mail-ru@f247.mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-----Original Message-----

>Recent releases of Solaris set the fs_clean state of an unmounted UFS file system as FSLOG ("logging fs"). However, the Linux kernel currently does not recognize the value which represents this state. Thus, attempting to mount such a file system rw produces the message
>
>kernel: ufs_read_super: can't grok fs_clean 0xfffffffd
>
>and the file system is mounted read-only. This patch makes the kernel recognize that value.
>

There is some minor style error. Do not forget use scripts/checkpatch.pl.
And may be better will be send copy to Andrew Morton <akpm@linux-foundation.org>,
instead of Linus Torvalds. He will be resend your patch to Linus, during next merge window.

Acked-by: Evgeniy Dushistov  +dushistov@mail.ru 

