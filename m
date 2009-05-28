Return-Path: <linux-kernel-owner+w=401wt.eu-S1758300AbZE1Lky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300AbZE1Lky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 07:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757396AbZE1LkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 07:40:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57790 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756245AbZE1LkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 07:40:13 -0400
Date: Thu, 28 May 2009 13:35:33 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/12 v2] ptrace: introduce task_struct->ptrace_cxt
Message-ID: <20090528113533.GA18670@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes:

	- renames as Ingo suggested

	- use task_lock() instead of cmpxchg() in _alloc()

	- comments update

New patches: move last_siginfo, ptrace_message, ptrace_entry.

Oleg.

