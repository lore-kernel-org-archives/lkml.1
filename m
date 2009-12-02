Return-Path: <linux-kernel-owner+w=401wt.eu-S1753105AbZLBKKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbZLBKKR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 05:10:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752869AbZLBKKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 05:10:16 -0500
Received: from mail.gmx.net ([213.165.64.20]:58484 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752001AbZLBKKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 05:10:15 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19uMZklWyFu4cf70eQ75gKv9ITBYFpBZyIQOPxVto
	a+qKT2kN8u9gOa
Subject: Re: [PATCH 3/7] sched: refactor try_to_wake_up()
From: Mike Galbraith <efault@gmx.de>
To: Tejun Heo <tj@kernel.org>
Cc: tglx@linutronix.de, mingo@elte.hu, avi@redhat.com, peterz@infradead.org,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
In-Reply-To: <4B16388F.90707@kernel.org>
References: <1259726212-30259-1-git-send-email-tj@kernel.org>
	 <1259726212-30259-4-git-send-email-tj@kernel.org>
	 <1259744733.6028.233.camel@marge.simson.net>  <4B16388F.90707@kernel.org>
Content-Type: text/plain
Date: Wed, 02 Dec 2009 11:10:18 +0100
Message-Id: <1259748618.6028.282.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.71
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-02 at 18:51 +0900, Tejun Heo wrote:
> Hello,

Greetings,

> > I think it would _look_ better with the thing just
> > duplicated/stripped down and called what it is,
> > sched_notifier_wakeup() or such.
> 
> Sorry, I'm not following.  Can you elaborate a bit?

I mean copying ttwu, stripping out locking etc, and renaming the result
would look better.  No functional difference though, and binary growth
would be left in the wake of such a duplication.

	-Mike

