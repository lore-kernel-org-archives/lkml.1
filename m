Return-Path: <linux-kernel-owner+w=401wt.eu-S1751934AbZL1Iow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbZL1Iow (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 03:44:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbZL1Iov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 03:44:51 -0500
Received: from casper.infradead.org ([85.118.1.10]:56212 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbZL1Iov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 03:44:51 -0500
Subject: Re: [RFC PATCH] asynchronous page fault.
From: Peter Zijlstra <peterz@infradead.org>
To: balbir@linux.vnet.ibm.com
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       cl@linux-foundation.org
In-Reply-To: <20091228025839.GF3601@balbir.in.ibm.com>
References: <20091225105140.263180e8.kamezawa.hiroyu@jp.fujitsu.com>
	 <1261912796.15854.25.camel@laptop>
	 <20091228005746.GE3601@balbir.in.ibm.com>
	 <20091228100514.ec6f9949.kamezawa.hiroyu@jp.fujitsu.com>
	 <20091228025839.GF3601@balbir.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Dec 2009 09:34:56 +0100
Message-ID: <1261989296.7135.6.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-28 at 08:28 +0530, Balbir Singh wrote:

> We can, but the data being on read-side is going to be out-of-date
> more than without the use of rcu_assign_pointer(). Do we need variants
> like to rcu_rb_next() to avoid overheads for everyone?

More or less doesn't matter! As long as you cannot get it atomic there's
holes and you need to deal with it.

