Return-Path: <linux-kernel-owner+w=401wt.eu-S1752065AbYECSmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065AbYECSmQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 14:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751065AbYECSl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 14:41:59 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:60474 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbYECSl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 14:41:59 -0400
Date: Sat, 3 May 2008 21:41:01 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: nommu compile error
Message-ID: <20080503184101.GO5838@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9f3acc3140444a900ab280de942291959f0f615d (split linux/file.h) 
causes the following compile error:

<--  snip  -->

...
  CC      fs/proc/task_nommu.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/proc/task_nommu.c: In function 'task_mem':
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/proc/task_nommu.c:49: error: dereferencing pointer to incomplete type
make[3]: *** [fs/proc/task_nommu.o] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

