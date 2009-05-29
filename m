Return-Path: <linux-kernel-owner+w=401wt.eu-S1757733AbZE2LYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733AbZE2LYJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 07:24:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754821AbZE2LX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 07:23:58 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:35428 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753991AbZE2LX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 07:23:57 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18975.50632.510546.193334@cargo.ozlabs.ibm.com>
Date: Fri, 29 May 2009 21:23:52 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] perf_counter: Don't swap contexts containing
	locked mutex
In-Reply-To: <18975.50009.814331.113052@cargo.ozlabs.ibm.com>
References: <18975.31580.520676.619896@drongo.ozlabs.ibm.com>
	<1243584388.23657.156.camel@twins>
	<1243584793.23657.168.camel@twins>
	<1243585721.23657.177.camel@twins>
	<20090529085916.GA21461@elte.hu>
	<20090529091608.GA15278@elte.hu>
	<18975.50009.814331.113052@cargo.ozlabs.ibm.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:

> Ah! We need to reload task inside the loop.  And possibly in other
> places.

I think at this point we need a pin_ctx function like Peter
suggested.  It will make it much simpler to fix this.  I'll hack
something up (if no-one beats me to it :).

Paul.
