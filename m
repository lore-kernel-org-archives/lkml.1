Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab0BMILo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 03:11:44 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:49547 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757Ab0BMILl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 03:11:41 -0500
To: linux-kernel@vger.kernel.org
Subject: [linux-2.6 linux-next] Can't "git pull"
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201002131711.EDB82658.FVOtJFMOSHOFLQ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 13 Feb 2010 17:11:38 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I can't "git pull" for linux-2.6 and linux-next tree.
Other trees seems to be OK.
Is this temporary problem?

$ cd ~/linux-2.6/
$ git pull origin master
fatal: http://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git/info/refs not found: did you run git update-server-info on the server?
$ cd ~/linux-next/
$ git pull origin master
fatal: http://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/info/refs not found: did you run git update-server-info on the server?
$ for i in 204.152.191.40 130.239.17.7 149.20.20.136 199.6.1.166; do curl http://$i/pub/scm/linux/kernel/git/torvalds/linux-2.6.git/info/refs; done
$ for i in 204.152.191.40 130.239.17.7 149.20.20.136 199.6.1.166; do curl http://$i/pub/scm/linux/kernel/git/next/linux-next.git/info/refs; done
$
