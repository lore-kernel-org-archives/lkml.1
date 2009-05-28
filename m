Return-Path: <linux-kernel-owner+w=401wt.eu-S1761685AbZE1QmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761685AbZE1QmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 12:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755232AbZE1QmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 12:42:13 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:48443 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbZE1QmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 12:42:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=dT+iXkXoKVTDcSX1i2eFr2jjtGxvI2Sbp0JZ0j6IBf5uCDf2IMsYEhULN+SkBhZ2Vj
         jNzDUcJnGif1lXLVdZnYII/zUc1pQwXUecw02U9kRDKF/KHcqzrs2xpWOu5D29SZHbw2
         yIbZVYdAB+pYPMOUxjaRuy64MH0GK+IVfI7CI=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 0/3] tracing/stat: fixes, cleanups
Date: Thu, 28 May 2009 18:42:07 +0200
Message-Id: <1243528930-5318-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are the latest histogram tracing core updates.
Those are about output fixes, memory leak fixes and code clarity.

Thanks,
Frederic.

The following changes since commit 53059c9b67a62a3dc8c80204d3da42b9267ea5a0:
  Frederic Weisbecker (1):
        tracing/stat: replace linked list by an rbtree for sorting

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git tracing/stat

Li Zefan (3):
      tracing/stat: change dummpy_cmp() to return -1
      tracing/stat: remember to free root node
      tracing/stat: do some cleanups

 kernel/trace/trace_stat.c |   60 ++++++++++++++++++---------------------------
 1 files changed, 24 insertions(+), 36 deletions(-)
