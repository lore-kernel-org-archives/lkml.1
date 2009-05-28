Return-Path: <linux-kernel-owner+w=401wt.eu-S1763959AbZE1Tc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763959AbZE1Tc5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 15:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757086AbZE1Tcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 15:32:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756861AbZE1Tct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 15:32:49 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: don't take tasklist to get/set ->last_siginfo
In-Reply-To: Oleg Nesterov's message of  Thursday, 28 May 2009 10:21:13 +0200 <20090528082113.GA9062@redhat.com>
References: <20090528082113.GA9062@redhat.com>
X-Shopping-List: (1) Ambiguous accordions
   (2) Surfing dandelions
   (3) Partial homestyle hay
Message-Id: <20090528193113.4825EFC2BD@magilla.sf.frob.com>
Date: Thu, 28 May 2009 12:31:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>

> Change ptrace_getsiginfo/ptrace_setsiginfo to use lock_task_sighand()
> without tasklist_lock. Perhaps it makes sense to make a singler helper
> with "bool rw" argument.

Let's not bother now since we will change this more later anyway.


Thanks,
Roland
