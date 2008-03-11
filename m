Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbYCKOwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbYCKOwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 10:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbYCKOwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 10:52:10 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:51764 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367AbYCKOwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 10:52:09 -0400
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Question regarding chmod/chown for /proc entries
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <200803112352.EGH60440.OJQFSFtOMFOVHL@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Tue, 11 Mar 2008 23:52:06 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

In 2.4 kernels, chmod/chown requests against /proc entries
return success but the mode/uid/gid aren't changed.

In 2.6 kernels, chmod/chown requests against /proc entries
return success and the mode/uid/gid are changed.

This is because 2.4 kernels don't update
"struct proc_dir_entry"->mode/uid/gid like 2.6 kernels.
( 2.4 kernels don't have proc_notify_change() hook.)

What's the reason for this difference?

Regards.
