Return-Path: <linux-kernel-owner+w=401wt.eu-S1760760AbZEFUe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760760AbZEFUe7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 16:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbZEFUeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 16:34:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbZEFUeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 16:34:50 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/3a] ptrace: add _ptrace_may_access()
In-Reply-To: Ingo Molnar's message of  Wednesday, 6 May 2009 10:00:50 +0200 <20090506080050.GF17457@elte.hu>
References: <20090505224729.GA965@redhat.com>
	<20090506080050.GF17457@elte.hu>
X-Zippy-Says: ALFRED JARRY!  Say something about th' DEATH of DISCO!!
Message-Id: <20090506203224.684C7FC39E@magilla.sf.frob.com>
Date: Wed,  6 May 2009 13:32:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Something like the patch below allows the reuse of the locked 
> version of __ptrace_may_access and pushes the int->bool conversion 
> into an inline.

I think it would be cleaner and safe/simple enough to invert the public
ptrace_may_access() to just return the int and invert the ! on all the
callers (all one in fs/proc/task_mmu.c and all four in fs/proc/base.c).


Thanks,
Roland
