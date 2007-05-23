Return-Path: <linux-kernel-owner+w=401wt.eu-S1759498AbXEWRoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759498AbXEWRoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 13:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756509AbXEWRnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 13:43:52 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34042 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755580AbXEWRnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 13:43:52 -0400
Date: Wed, 23 May 2007 10:43:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: cpw@sgi.com (Cliff Wickman)
Cc: linux-kernel@vger.kernel.org, Paul Jackson <pj@sgi.com>,
       Christoph Lameter <christoph@lameter.com>,
       Paul Menage <menage@google.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/1] hotplug cpu: migrate a task within its cpuset
Message-Id: <20070523104315.6b9089dc.akpm@linux-foundation.org>
In-Reply-To: <4651FC58.mailxOWT1QTGD9@eag09.americas.sgi.com>
References: <4651FC58.mailxOWT1QTGD9@eag09.americas.sgi.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2007 15:08:56 -0500 cpw@sgi.com (Cliff Wickman) wrote:

> (this is a third submission -- corrects a locking/blocking issue pointed
>  out by Nathan Lynch)
> 
> When a cpu is disabled, move_task_off_dead_cpu() is called for tasks
> that have been running on that cpu.

So I still have these three patches in the pending queue but I was rather
hoping that the scheduler, sched-domains and cpuset people could take a
look at them, please.

They hit sched.c and cpuset.c mainly, and they might trash Ingo's CFS patch
(I haven't checked).

