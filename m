Return-Path: <linux-kernel-owner+w=401wt.eu-S1757594AbYBEC2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594AbYBEC2q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 21:28:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756135AbYBEC2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 21:28:35 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:56585 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756127AbYBEC2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 21:28:35 -0500
Message-Id: <200802050228.m152SWFx099347@www262.sakura.ne.jp>
Subject: What id does \"current->pid\" indicate?
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Date: Tue, 05 Feb 2008 11:28:32 +0900
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I found that there are "current->pid", "task_pid_vnr(current)"
and "task_pid_nr(current)" cases in kernel 2.6.24 .

According to include/linux/pid.h ,
"task_pid_nr()" is global id and "task_xid_vnr()" is virtual id.
But what id does "current->pid" indicate?
Is "current->pid" equivalent to "task_pid_nr(current)" ?

Regards.
