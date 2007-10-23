Return-Path: <linux-kernel-owner+w=401wt.eu-S1753154AbXJWGTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbXJWGTj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 02:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbXJWGTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 02:19:30 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40673 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751178AbXJWGTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 02:19:30 -0400
Date: Mon, 22 Oct 2007 23:19:25 -0700
From: Paul Jackson <pj@sgi.com>
To: "Paul Menage" <menage@google.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, mingo@elte.hu, dmitry.adamushko@gmail.com,
       ghaskins@novell.com, a.p.zijlstra@chello.nl
Subject: Re: [PATCH -v2 4/7] RT overloaded runqueues accounting
Message-Id: <20071022231925.2b996db8.pj@sgi.com>
In-Reply-To: <6599ad830710222311x402c3d1agcc458742fb5e219c@mail.gmail.com>
References: <20071023025900.927578809@goodmis.org>
	<20071023032916.651749224@goodmis.org>
	<20071022211709.7be79fea.pj@sgi.com>
	<6599ad830710222311x402c3d1agcc458742fb5e219c@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul M wrote:
> Cgroups doesn't change the locking rules for accessing a cpuset from a
> task - you have to have one of:

Good - could you comment task_cs() with this explanation?

The rules are derived from the cpuset rules, as you explain,
and as I suspected, but now task_cs() is the most popular
way to access a tasks cpuset from code within kernel/cpuset.c,
and that's code you added.

The reason that I started this subthread is that I didn't see
any immediate evidence that the RT code was honoring this locking,
and I suspected that I clear comment over task_cs() could have
clarified that for them.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
