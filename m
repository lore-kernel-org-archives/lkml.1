Return-Path: <linux-kernel-owner+w=401wt.eu-S1753630AbZFVQQD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630AbZFVQQD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 12:16:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751982AbZFVQPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 12:15:55 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52992 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857AbZFVQPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 12:15:54 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090622160753.GE6754@linux.vnet.ibm.com>
References: <20090622160753.GE6754@linux.vnet.ibm.com> <20090506225115.GM6771@linux.vnet.ibm.com> <20090506112459.5edd0902.akpm@linux-foundation.org> <20090502163423.GA1633@linux.vnet.ibm.com> <12234.1241558327@redhat.com> <20090506120909.GR25203@elte.hu> <11979.1241648574@redhat.com> <26931.1245670998@redhat.com> <20090622124951.GB30553@elte.hu> <20090622082941.c5c8b3f3.akpm@linux-foundation.org> 
To: paulmck@linux.vnet.ibm.com
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       niv@us.ibm.com, dvhltc@us.ibm.com, lethal@linux-sh.org,
       kernel@wantstofly.org, matthew@wil.cx
Subject: Re: [PATCH] v4 RCU: the bloatwatch edition
Date: Mon, 22 Jun 2009 17:15:29 +0100
Message-ID: <4851.1245687329@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Of course, I well remember programming systems with 4K of core memory
> back in the 1970s, and therefore feel a bit guilty about sticking deep
> embedded platforms with the increase in memory footprint represented
> by Hierarchical RCU compared to Classic RCU.  And Bloatwatch RCU is much
> smaller and easier to understand/maintain than is Classic RCU.

Both Fujitsu and Panasonic really want to keep the kernel size down.
Squeezing a kernel into a megabyte or less of flash is one of the main aims,
and anything that saves nearly 1K is not to be sneered at.

David
