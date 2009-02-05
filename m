Return-Path: <linux-kernel-owner+w=401wt.eu-S1756932AbZBEDQD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932AbZBEDQD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 22:16:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbZBEDPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 22:15:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709AbZBEDPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 22:15:50 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Lin Ming <ming.m.lin@intel.com>, Peter Zijlstra <peterz@infradead.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ia64: ptrace_attach_sync_user_rbs: use ->sighand
	instead of ->signal to check the task is alive
In-Reply-To: Oleg Nesterov's message of  Wednesday, 4 February 2009 00:17:11 +0100 <20090203231711.GA5020@redhat.com>
References: <20090203231711.GA5020@redhat.com>
X-Shopping-List: (1) Asynchronous furious dwarves
   (2) Auspicious delusion expulsions
   (3) Geriatric diffident ripping-cats
Message-Id: <20090205031528.1018AFC381@magilla.sf.frob.com>
Date: Wed,  4 Feb 2009 19:15:28 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Actually, this code doesn't need tasklist_lock and this check at all, it
> should be converted to use lock_task_sighand().

Might as well just do that, it's a harmless enough change.  For other
trivial no-op cleanup while you are there, task_is_stopped() and
task_is_traced() are the norm now.


Thanks,
Roland
