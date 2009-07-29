Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbZG2VqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbZG2VqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 17:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753178AbZG2VqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 17:46:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60183 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154AbZG2VqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 17:46:20 -0400
Date: Wed, 29 Jul 2009 23:42:18 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizf@cn.fujitsu.com>,
       Miao Xie <miaox@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: [PATCH 0/1] cpu_hotplug: don't play with current->cpus_allowed
Message-ID: <20090729214218.GA24631@redhat.com>
References: <20090729023302.GA8899@redhat.com> <20090729212125.GA16970@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090729212125.GA16970@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am suggesting this patch instead of

	cpu_hotplug-dont-affect-current-tasks-affinity.patch
	http://marc.info/?l=linux-mm-commits&m=124830024011314

in -mm tree.

Of course this is subjective, but it really looks simpler to me.

Not a big deal though, I am sending it mostly because nobody
replied to my question, and I had to actually compile and test
this patch ;)

Thoughts?

Oleg.

