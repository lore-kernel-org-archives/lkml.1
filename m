Return-Path: <linux-kernel-owner+w=401wt.eu-S1752831AbYJUGKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbYJUGKb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 02:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755AbYJUGKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 02:10:20 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:46972 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742AbYJUGKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 02:10:19 -0400
Date: Tue, 21 Oct 2008 09:09:45 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Arch x86 is not supported with CONFIG_FTRACE_MCOUNT_RECORD
Message-ID: <20081021060945.GA14126@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 8da3821ba5634497da63d58a69e24a97697c4a2b
(ftrace: create __mcount_loc section) causes the
following build error:

<--  snip  -->

$ make ARCH=x86
...
  CC      scripts/mod/empty.o
Arch x86 is not supported with CONFIG_FTRACE_MCOUNT_RECORD at /home/bunk/linux/kernel-2.6/git/linux-2.6/scripts/recordmcount.pl line 157.
make[3]: *** [scripts/mod/empty.o] Error 255

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

