Return-Path: <linux-kernel-owner+w=401wt.eu-S1757245AbZEEVUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245AbZEEVUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 17:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbZEEVUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 17:20:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36251 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbZEEVUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 17:20:22 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090502163423.GA1633@linux.vnet.ibm.com>
References: <20090502163423.GA1633@linux.vnet.ibm.com>
To: paulmck@linux.vnet.ibm.com
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       akpm@linux-foundation.org, niv@us.ibm.com, dvhltc@us.ibm.com,
       lethal@linux-sh.org, kernel@wantstofly.org, matthew@wil.cx
Subject: Re: [PATCH] v4 RCU: the bloatwatch edition
Date: Tue, 05 May 2009 22:18:47 +0100
Message-ID: <12234.1241558327@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> This patch is a version of RCU designed for (!SMP && EMBEDDED)
> provided as a proof of concept of a small-footprint RCU implementation.
> In particular, the implementation of synchronize_rcu() is extremely
> lightweight and high performance.  It passes rcutorture testing in each
> of the four relevant configurations (combinations of NO_HZ and PREEMPT)
> on x86.  This saves about 900 bytes compared to Classic RCU, and a
> couple kilobytes compared to Hierarchical RCU (updated to 2.6.29):
> ...
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Acked-by: David Howells <dhowells@redhat.com>
