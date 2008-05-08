Return-Path: <linux-kernel-owner+w=401wt.eu-S1756336AbYEHI0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336AbYEHI0J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 04:26:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbYEHIZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 04:25:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50593 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752774AbYEHIZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 04:25:55 -0400
Date: Thu, 8 May 2008 01:25:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-kernel@vger.kernel.org, Pierre Peiffer <peifferp@gmail.com>
Subject: Re: futex: priority wakeup miss ordering
Message-Id: <20080508012503.0d023cdc.akpm@linux-foundation.org>
In-Reply-To: <1210195378.17132.237.camel@localhost.localdomain>
References: <1210195378.17132.237.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 May 2008 14:22:58 -0700 Daniel Walker <dwalker@mvista.com> wrote:

> 
> 
> from commit ec92d08292d3e9b0823eba138a4564d2d39f25c7
> 
> The wakeup ordering should be in priority order. However if the priority
> of a task is modified while it's waiting on the futex you will get an
> out of order wakeup.
> 
> If you use a priority inheriting mutex this is correct. It's because the
> rtmutex hooks into sched_setscheduler to catch any priority changes,
> then re-queues with the new priority.. But the futex doesn't have this
> hook.
> 
> Was this intentionally left out of this priority wake up patch? I
> thought I would let you know in case you had a specific reason for not
> handling this.. 
> 

Pierre is no longer @bull.net.
