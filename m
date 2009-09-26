Return-Path: <linux-kernel-owner+w=401wt.eu-S1753116AbZIZQUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116AbZIZQUv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 12:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753067AbZIZQUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 12:20:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055AbZIZQUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 12:20:49 -0400
Date: Sat, 26 Sep 2009 12:20:40 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC PATCH] perf_core: provide a kernel-internal interface to get to performance counters
Message-ID: <20090926162040.GA17819@redhat.com>
References: <20090925122556.2f8bd939@infradead.org> <y0mhbuplmlr.fsf@fche.csb> <20090926181149.6e5827db@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090926181149.6e5827db@infradead.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Sat, Sep 26, 2009 at 06:11:49PM +0200, Arjan van de Ven wrote:
> [...]
> your appearance is not correct. A perf counter is either attached to a
> task, or to a cpu. I use the later.

OK, that explains the "MUST be called from kernel thread" comment --
so that the ->owner and get/put_task_struct in the new create/free
functions all refer to that kernel thread.  Thanks.

- FChE
