Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbZBDLEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbZBDLEq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 06:04:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752715AbZBDLEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 06:04:38 -0500
Received: from ozlabs.org ([203.10.76.45]:41479 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623AbZBDLEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 06:04:37 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 3/4] kthreads: rework kthread_stop()
Date: Wed, 4 Feb 2009 21:34:31 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: paulmck@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>, Vitaliy Gusev <vgusev@openvz.org>,
       linux-kernel@vger.kernel.org
References: <20090130123358.GA26216@redhat.com> <20090203134110.GC6607@linux.vnet.ibm.com> <m1ocxivlch.fsf@fess.ebiederm.org>
In-Reply-To: <m1ocxivlch.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902042134.32346.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 February 2009 15:40:06 Eric W. Biederman wrote:
> static struct kthread *to_kthread(struct task_struct *tsk)
> {
> 	void *stack = task_stack_page(tsk);
> 	return (struct kthread *)(stack + kthread_offset);
>         
> }
...
> It would remove the test and be simple and obviously correct.

Clever? Sure.  Neat? Yes.

But you are using a definition of obvious with which I was not previously
familiar :)

Rusty.
