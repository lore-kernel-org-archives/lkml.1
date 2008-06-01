Return-Path: <linux-kernel-owner+w=401wt.eu-S1753933AbYFAPaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbYFAPaX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 11:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbYFAP3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 11:29:17 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:58895 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455AbYFAP3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 11:29:15 -0400
Date: Sun, 1 Jun 2008 19:30:41 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] s/PF_BORROWED_MM/PF_KTHREAD/
Message-ID: <20080601153041.GA8235@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first 2 patches were silently ignored, resend. I don't really understand
who should be cc'ed on this.

The third one is an example. Obviously we can fix the problem without changing
use_mm/PF_BORROWED_MM, but in that case we must do task_lock/unlock for each
process in the system, not good and annoying.

Oleg.

