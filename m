Return-Path: <linux-kernel-owner+w=401wt.eu-S1754831AbYLBXVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831AbYLBXVG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 18:21:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbYLBXUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 18:20:54 -0500
Received: from one.firstfloor.org ([213.235.205.2]:60102 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbYLBXUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 18:20:53 -0500
Date: Wed, 3 Dec 2008 00:31:44 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org, manfred@colorfullife.com,
       dipankar@in.ibm.com, josht@linux.vnet.ibm.com, schamp@sgi.com,
       niv@us.ibm.com, dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, penberg@cs.helsinki.fi,
       andi@firstfloor.org, tglx@linutronix.de
Subject: Re: [PATCH -tip] v9 scalable classic RCU implementation
Message-ID: <20081202233144.GE6703@one.firstfloor.org>
References: <20081202222157.GA14911@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081202222157.GA14911@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> o	I now test with a more brutal random-selection online/offline
> 	script (attached).  Probably more brutal than it needs to be
> 	on the people reading it as well, but so it goes.

Does that cover both dynticks on and off? afaik the dynticks off problem
I ran into on a 16 thread box and we discussed some time ago is still there.

-Andi
