Return-Path: <linux-kernel-owner+w=401wt.eu-S1763263AbZCaPbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763263AbZCaPbH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 11:31:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763156AbZCaPa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 11:30:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52972 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763187AbZCaPa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 11:30:28 -0400
Date: Tue, 31 Mar 2009 17:26:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Roland McGrath <roland@redhat.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 0/3] add rt_tgsigqueueinfo syscall -V2
Message-ID: <20090331152610.GC4792@redhat.com>
References: <20090324102516.459441533@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324102516.459441533@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24, Thomas Gleixner wrote:
>
> sys_kill has a counterpart sys_tgkill which allows to send signals to
> a particular thread. sys_rt_sigqueueinfo is lacking such a counterpart.
>
> Aside of the asymetry it is a show stopper for migrating applications
> from other unix-alike RTOSes.
>
> The following patch series implements rt_tgsigqueueinfo and hooks it
> up for x86.
>
> Changes since V1:
>     - match rt_siqqueueinfo and rt_tgsigqueueinfo handling of
>       info.si_pid/si_uid

I think this all is correct. And I think "Changes since V1" are good,
rt_tgsigqueueinfo() should not play with si_pid/si_uid.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>

