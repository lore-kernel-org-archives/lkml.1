Return-Path: <linux-kernel-owner+w=401wt.eu-S1754938Ab0A2Ui7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938Ab0A2Ui7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 15:38:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754875Ab0A2Ui6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 15:38:58 -0500
Received: from www.tglx.de ([62.245.132.106]:44713 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754868Ab0A2Ui6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 15:38:58 -0500
Message-Id: <20100129203549.526478432@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 29 Jan 2010 20:38:29 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 00/10] semaphore to mutex conversions
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series converts semaphores which are semantically
mutexes to real mutexes. This is part of the effort to remove
init_MUTEX*

Most of the patches have been in the -rt tree for quite a while with
no bad side effects.

Thanks,

	tglx



