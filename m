Return-Path: <linux-kernel-owner+w=401wt.eu-S1758753AbZJMGGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758753AbZJMGGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 02:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756170AbZJMGGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 02:06:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62411 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752990AbZJMGGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 02:06:33 -0400
Message-ID: <4AD4189B.2000308@cn.fujitsu.com>
Date: Tue, 13 Oct 2009 14:05:15 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, avi@redhat.com,
       mtosatti@redhat.com, torvalds@linux-foundation.org
Subject: Re: [PATCH RFC tip/core/rcu 1/3] rcu: The Bloatwatch Edition, v7
References: <20091009224954.GA26516@linux.vnet.ibm.com> <4AD2F6F5.2060101@cn.fujitsu.com> <20091012173006.GC6764@linux.vnet.ibm.com>
In-Reply-To: <20091012173006.GC6764@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> Hmmmm...  Does this apply even when called from ksoftirqd?
> 
> Adding the local_irq_save() just out of paranoia for the moment.
> And therefore moving the local_irq_save() down to the common
> rcu_qsctr_help() function.  Which I am renaming to rcu_qs_help()
> for consistency.
> 
> Or am I missing something here?
> 


You are right! local_irq_save() is needed.

Lai
