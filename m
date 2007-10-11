Return-Path: <linux-kernel-owner+w=401wt.eu-S1758146AbXJKNZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146AbXJKNZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 09:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753803AbXJKNZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 09:25:22 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:65508 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752520AbXJKNZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 09:25:21 -0400
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: chrisw@sous-sol.org
Subject: [TOMOYO #4 00/13] TOMOYO Linux - MAC based on process invocation history.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <200710112225.HGI87594.FVLFOFMJtHSOQO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Thu, 11 Oct 2007 22:25:17 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"TOMOYO Linux" is our work in the field of security enhanced Linux.
This is the fourth submission of TOMOYO Linux
( http://lkml.org/lkml/2007/10/2/170 ).

Thank you very much for feedbacks on previous submission.
We followed the following comments and now submitting again.

 * Replace "struct semaphore" with "struct mutex".
 * Replace singly linked list with standard RCU list.

and we

 * Refreshed patches based on 2.6.23
 * Fixed some bugs.

We replaced list manipulation using RCU,
but we think that we are "over-protecting for append-only-list"
and "disabling preemption for very long time".
Mentioning optimizing and incorrect RCU usage are welcome.

This time, we excluded LSM expansion and related functions.

Documents about installing and experiencing TOMOYO Linux
are available at http://tomoyo.sourceforge.jp/en/lkml-4/ .


By the way, you can try TOMOYO Linux 1.5.0 on Ubuntu 7.04's Live CD.
http://tomoyo.sourceforge.jp/wiki-e/?TomoyoLive

