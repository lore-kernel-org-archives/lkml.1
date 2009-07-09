Return-Path: <linux-kernel-owner+w=401wt.eu-S1750948AbZGIXFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750948AbZGIXFw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 19:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750717AbZGIXFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 19:05:44 -0400
Received: from tundra.namei.org ([65.99.196.166]:45640 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695AbZGIXFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 19:05:43 -0400
Date: Fri, 10 Jul 2009 09:04:47 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Oleg Nesterov <oleg@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Roland McGrath <roland@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/2] rename is_single_threaded(task) to
 is_current_single_threaded(void)
In-Reply-To: <20090709212847.GA10238@redhat.com>
Message-ID: <alpine.LRH.2.00.0907100904240.8531@tundra.namei.org>
References: <20090709212847.GA10238@redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jul 2009, Oleg Nesterov wrote:

> (on top of rework-fix-is_single_threaded.patch)
> 
> - is_single_threaded(task) is not safe unless task == current,
>   we can't use task->signal or task->mm.
> 
> - it doesn't make sense unless task == current, the task can
>   fork right after the check.
> 
> Rename it to is_current_single_threaded() and kill the argument.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: James Morris <jmorris@namei.org>

-- 
James Morris
<jmorris@namei.org>
