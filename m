Return-Path: <linux-kernel-owner+w=401wt.eu-S1753653AbZBHSt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653AbZBHSt7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 13:49:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbZBHStu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 13:49:50 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36114 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557AbZBHStt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 13:49:49 -0500
Date: Sun, 8 Feb 2009 19:47:20 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jerome Marchand <jmarchan@redhat.com>, Roland McGrath <roland@redhat.com>,
       Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 0/3] ptrace: detach wakeup fixes
Message-ID: <20090208184720.GA27070@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On top of misc ptrace patches in -mm.

Q: when the tracer exits we bypass ptrace_disable() and
clear_tsk_thread_flag(TIF_SYSCALL_TRACE), is this correct?

Perhaps we should move this code into __ptrace_unlink?

Oleg.

