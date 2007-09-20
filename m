Return-Path: <linux-kernel-owner+w=401wt.eu-S1755839AbXITM5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839AbXITM5M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 08:57:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbXITM46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 08:56:58 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:64391 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753718AbXITM45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 08:56:57 -0400
To: linux-kernel@vger.kernel.org
Subject: error from checkpatch.pl version 0.10
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <200709202156.GFC11109.HOFQLOVOFFtSJM@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50]
X-Accept-Language: ja,en
Date: Thu, 20 Sep 2007 21:56:59 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I checked my patch using checkpatch.pl version 0.10
and I got the following error.

  ERROR: need consistent spacing around '*' (ctx:WxV)
  #2334: FILE: security/tomoyo/common.c:2306:
  +static unsigned int tmy_poll(struct file *file, poll_table *wait)
                                                              ^

What action should I take?
Ignore this error because "poll_table" is used everywhere?
Replace "poll_table" with "struct poll_table_struct" according to
definition of "poll_table"?

  typedef struct poll_table_struct {
          poll_queue_proc qproc;
  } poll_table;

Regards.
