Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbYH0CjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbYH0CjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 22:39:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbYH0Ci6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 22:38:58 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:53225 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278AbYH0Ci5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 22:38:57 -0400
Date: Tue, 26 Aug 2008 21:38:57 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, Robert Rex <robert.rex@exasol.com>,
       Roland McGrath <roland@redhat.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] pid_ns: kill the now unused task_child_reaper()
Message-ID: <20080827023857.GC2320@us.ibm.com>
References: <20080824154913.GA3786@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080824154913.GA3786@tv-sign.ru>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oleg Nesterov (oleg@tv-sign.ru):
> task_child_reaper() has no callers anymore, kill it.
> 
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

Acked-by: Serge Hallyn <serue@us.ibm.com>

> --- 2.6.27-rc4/include/linux/pid_namespace.h~4_KILL_HELPER	2008-07-30 13:12:48.000000000 +0400
> +++ 2.6.27-rc4/include/linux/pid_namespace.h	2008-08-24 19:33:12.000000000 +0400
> @@ -84,12 +84,6 @@ static inline struct pid_namespace *task
>  	return tsk->nsproxy->pid_ns;
>  }
> 
> -static inline struct task_struct *task_child_reaper(struct task_struct *tsk)
> -{
> -	BUG_ON(tsk != current);
> -	return tsk->nsproxy->pid_ns->child_reaper;
> -}
> -
>  void pidhash_init(void);
>  void pidmap_init(void);
> 
