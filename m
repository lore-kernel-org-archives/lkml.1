Return-Path: <linux-kernel-owner+w=401wt.eu-S1756149AbZGATbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149AbZGATbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 15:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754320AbZGATbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 15:31:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:32969 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbZGATbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 15:31:24 -0400
Date: Wed, 1 Jul 2009 21:28:42 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] ptrace: __ptrace_detach: do __wake_up_parent() if we
	reap the tracee
Message-ID: <20090701192842.GA26616@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, please temporary drop

	signals-shift-security_task_wait-from-eligible_child-to-wait_consider_task.patch
	signals-change-__wake_up_parent-to-use-filtered-wakeup.patch

They are correct (I think), and I will re-send them.

But I have found an unrelated bug which should be fixed first, and
the fix textually depends on these patches.

Oleg.

