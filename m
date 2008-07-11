Return-Path: <linux-kernel-owner+w=401wt.eu-S1758146AbYGKTWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146AbYGKTWh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 15:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758067AbYGKTTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 15:19:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42313 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759904AbYGKTTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 15:19:39 -0400
Date: Fri, 11 Jul 2008 12:18:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Hideo AOKI <haoki@redhat.com>,
       Takahiro Yasui <tyasui@redhat.com>
Subject: Re: [PATCH -mm] markers: avoid call_rcu_sched if old is NULL
Message-Id: <20080711121842.070c1342.akpm@linux-foundation.org>
In-Reply-To: <20080709030200.GA4378@Krystal>
References: <4873CE05.2030001@redhat.com>
	<20080709030200.GA4378@Krystal>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jul 2008 23:02:01 -0400 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> * Masami Hiramatsu (mhiramat@redhat.com) wrote:
> > Introduce marker_entry_free_old() and check old pointer is NULL before
> > setting call_rcu_sched(), because marker_entry_remove/add_probe() can
> > return NULL.
> > 
> 
> Hi Masami,
> 
> I doubt this is a bug per se, because kfree accepts NULL pointers (and
> kfree is the only action done on the oldptr by free_old_closure).
> 
> This cleans up the code, so I think it's good to merge your patch, but I
> would definitely not classify this as a bugfix.
> 
> Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

I cannot get this to apply on the rather dated tree which I have on this
rather not-on-the-internet machine.  Please merge this patch locally, test,
rewrite the changelog and resend it to someone ;)

