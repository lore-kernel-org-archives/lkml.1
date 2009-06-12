Return-Path: <linux-kernel-owner+w=401wt.eu-S1763717AbZFLOt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763717AbZFLOt3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 10:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbZFLOtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 10:49:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50828 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbZFLOtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 10:49:21 -0400
Date: Fri, 12 Jun 2009 16:44:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] posix-cpu-timers: remove tasklist_lock where we can
Message-ID: <20090612144438.GD3784@redhat.com>
References: <20090612103412.3c490e3e@dhcp-lab-109.englab.brq.redhat.com> <20090612140044.GB3784@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090612140044.GB3784@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12, Oleg Nesterov wrote:
>
> This reminds me. !CPUCLOCK_PERTHREAD timers survive after exec, but only
> if ->group_leader execs. Not good.

Perhaps cpu_timer_list should use "struct pid *" instead of
"struct task_struct *", but this requires a lot of changes.

Oleg.

