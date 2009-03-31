Return-Path: <linux-kernel-owner+w=401wt.eu-S1762660AbZCaGu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762660AbZCaGu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 02:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758081AbZCaGur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 02:50:47 -0400
Received: from www.tglx.de ([62.245.132.106]:49019 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754145AbZCaGuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 02:50:46 -0400
Date: Tue, 31 Mar 2009 08:49:29 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Darren Hart <dvhltc@us.ibm.com>
cc: linux-kernel@vger.kernel.org, Sripathi Kodi <sripathik@in.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       John Stultz <johnstul@us.ibm.com>, Steven Rostedt <rostedt@goodmis.org>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>,
       Sripathi Kodi <sripathik@in.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       John Stultz <johnstul@us.ibm.com>, Steven Rostedt <rostedt@goodmis.org>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>
Subject: Re: [tip PATCH v6 3/8] RFC: futex: futex_lock_pi_atomic()
In-Reply-To: <20090330213755.606.39013.stgit@Aeon>
Message-ID: <alpine.LFD.2.00.0903310845550.12916@localhost.localdomain>
References: <20090330213306.606.9540.stgit@Aeon> <20090330213755.606.39013.stgit@Aeon>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Mar 2009, Darren Hart wrote:
> +static int futex_lock_pi_atomic(u32 __user *uaddr, struct futex_hash_bucket *hb,
> +				union futex_key *key,
> +				struct futex_pi_state **ps,
> +				struct task_struct *task)
> +{
> +	u32 uval, newval, curval;
> +	int lock_taken;
> +	int ret;
> +	int ownerdied = 0;

  int lock_taken, ret, ownerdied = 0;

Thanks,

	tglx
