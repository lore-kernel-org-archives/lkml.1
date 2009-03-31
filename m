Return-Path: <linux-kernel-owner+w=401wt.eu-S1760524AbZCaCKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760524AbZCaCKI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 22:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755037AbZCaCJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 22:09:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:55859 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241AbZCaCJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 22:09:55 -0400
Date: Mon, 30 Mar 2009 22:09:50 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Darren Hart <dvhltc@us.ibm.com>
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Sripathi Kodi <sripathik@in.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       John Stultz <johnstul@us.ibm.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>
Subject: Re: [tip PATCH v6 0/8] requeue pi implementation
In-Reply-To: <20090330213306.606.9540.stgit@Aeon>
Message-ID: <alpine.DEB.2.00.0903302208390.3843@gandalf.stny.rr.com>
References: <20090330213306.606.9540.stgit@Aeon>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Mon, 30 Mar 2009, Darren Hart wrote:
> 
> Darren Hart (8):
>       RFC: futex: add requeue_pi calls
>       RFC: futex: Add requeue_futex() call
>       RFC: futex: Add FUTEX_HAS_TIMEOUT flag to restart.futex.flags

I just finished reviewing the first three patches, and I don't see 
anything wrong with them. I'll review more tomorrow, but just for now, you 
can add on to the first three:

Reviewed-by: Steven Rostedt <srostedt@redhat.com>

-- Steve


>       RFC: rt_mutex: add proxy lock routines
>       RFC: futex: finish_futex_lock_pi()
>       RFC: futex: futex_lock_pi_atomic()
>       RFC: futex: futex_top_waiter()
>       RFC: futex: futex_wait_queue_me()
> 
