Return-Path: <linux-kernel-owner+w=401wt.eu-S1754332AbZIJUx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332AbZIJUx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 16:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754251AbZIJUx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 16:53:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:40502 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbZIJUx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 16:53:58 -0400
Subject: Re: [PATCH 0/3] resend, cpuset/hotplug fixes
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Gautham Shenoy <ego@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Jiri Slaby <jirislaby@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Miao Xie <miaox@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
In-Reply-To: <20090910192153.GA584@redhat.com>
References: <20090910192153.GA584@redhat.com>
Content-Type: text/plain
Date: Thu, 10 Sep 2009 22:53:16 +0200
Message-Id: <1252615996.7205.99.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-10 at 21:21 +0200, Oleg Nesterov wrote:
> (my apologies to those who see this twice).
> 
> 
> The 1st patch is preparation. 2-3 fix different problems, the 3rd one
> depends on 2nd.
> 
> These patches change the code which I don't really understand, please
> review.
> 
> 
> As for the 3rd patch, it replaces
> 
> 	cpu_hotplug-dont-affect-current-tasks-affinity.patch
> 
> in -mm tree. Imho the new patch is more simple and clean, but of course
> this is subjective and I am biased.

Look good to me.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Ingo, will you stick them in -tip?

