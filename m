Return-Path: <linux-kernel-owner+w=401wt.eu-S1753441AbZJBAmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbZJBAmo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 20:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbZJBAmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 20:42:43 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51608 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbZJBAmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 20:42:43 -0400
To: Tejun Heo <tj@kernel.org>
Cc: jeff@garzik.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, ar@firstfloor.org
Subject: Re: [PATCH 19/19] workqueue: implement concurrency managed workqueue
From: Andi Kleen <andi@firstfloor.org>
References: <1254384558-1018-1-git-send-email-tj@kernel.org>
	<1254384558-1018-20-git-send-email-tj@kernel.org>
Date: Fri, 02 Oct 2009 02:42:45 +0200
In-Reply-To: <1254384558-1018-20-git-send-email-tj@kernel.org> (Tejun Heo's message of "Thu,  1 Oct 2009 17:09:18 +0900")
Message-ID: <87ws3esk1m.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Currently each workqueue has its own dedicated worker pool.  This
> causes the following problems.

I definitely like the basic idea (without having read all the code so
far).  Thanks for doing that work. On large systems the number of
kernel threads around can be mind boggling, and it will also get rid
of bizarreness like the ps2mouse thread.

I wonder have you ever thought about exposing this to user space too?
It can face similar problems for parallelization.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
