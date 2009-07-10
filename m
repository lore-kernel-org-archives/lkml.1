Return-Path: <linux-kernel-owner+w=401wt.eu-S1756160AbZGJOJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160AbZGJOJJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 10:09:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754828AbZGJOIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 10:08:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34456 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755737AbZGJOIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 10:08:40 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090710014823.GB4723@redhat.com>
References: <20090710014823.GB4723@redhat.com> <20090709212847.GA10238@redhat.com> <20090710013322.GA27719@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Roland McGrath <roland@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 -mm 1/2] rename is_single_threaded(task) to current_is_single_threaded(void)
Date: Fri, 10 Jul 2009 15:07:24 +0100
Message-ID: <25959.1247234844@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> - is_single_threaded(task) is not safe unless task == current,
>   we can't use task->signal or task->mm.
> 
> - it doesn't make sense unless task == current, the task can
>   fork right after the check.
> 
> Rename it to current_is_single_threaded() and kill the argument.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Acked-by: James Morris <jmorris@namei.org>

Acked-by: David Howells <dhowells@redhat.com>
