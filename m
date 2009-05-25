Return-Path: <linux-kernel-owner+w=401wt.eu-S1752803AbZEYTAC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbZEYTAC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 15:00:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbZEYS7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 14:59:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49830 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453AbZEYS7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 14:59:54 -0400
Date: Mon, 25 May 2009 20:54:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>, Roland McGrath <roland@redhat.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] ptrace: do_notify_parent_cldstop: fix the wrong
	->nsproxy usage
Message-ID: <20090525185457.GA20773@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does not depend on other ptrace changes in -mm, and it can
go ahead to fix the old but fortunately minor bug.

I noticed it while doing

	[RFC PATCH 7/X] ptrace: mv task->parent ptrace_task->pt_tracer
	http://marc.info/?l=linux-kernel&m=124321008612056

which fixes this problem too, but I think it is better to separate
cleanups and fixes.

Oleg.

