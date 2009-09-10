Return-Path: <linux-kernel-owner+w=401wt.eu-S1753537AbZIJT0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbZIJT0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 15:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbZIJT0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 15:26:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31593 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753256AbZIJT0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 15:26:37 -0400
Date: Thu, 10 Sep 2009 21:21:53 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gautham Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Jiri Slaby <jirislaby@gmail.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>,
       Paul Menage <menage@google.com>, Peter Zijlstra <peterz@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] resend, cpuset/hotplug fixes
Message-ID: <20090910192153.GA584@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(my apologies to those who see this twice).


The 1st patch is preparation. 2-3 fix different problems, the 3rd one
depends on 2nd.

These patches change the code which I don't really understand, please
review.


As for the 3rd patch, it replaces

	cpu_hotplug-dont-affect-current-tasks-affinity.patch

in -mm tree. Imho the new patch is more simple and clean, but of course
this is subjective and I am biased.

Oleg.

