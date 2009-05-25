Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157AbZEYU1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbZEYU1D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 16:27:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752990AbZEYU0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 16:26:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45972 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752508AbZEYU0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 16:26:52 -0400
Date: Mon, 25 May 2009 22:21:40 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] ptrace: wait_task_zombie: s/->parent/->real_parent/
Message-ID: <20090525202140.GA25235@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another chunk from

	[RFC PATCH 7/X] ptrace: mv task->parent ptrace_task->pt_tracer
	http://marc.info/?l=linux-kernel&m=124321008612056

which is not just s/->parent/->ptrace_task->pt_tracer/.

Cleanup/preparation, no functional changes. I didn't notice this
"->parent" when I did other "do not use ->parent" cleanups.

Oleg.

