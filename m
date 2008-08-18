Return-Path: <linux-kernel-owner+w=401wt.eu-S1753014AbYHRLvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014AbYHRLvy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 07:51:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbYHRLvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 07:51:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:39945 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbYHRLvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 07:51:45 -0400
Subject: Re: SCHED_FIFO and SCHED_RR broken by cfs
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Torvalds, Linus" <torvalds@linux-foundation.org>,
       Stefani Seibold <stefani@seibold.net>, linux-kernel@vger.kernel.org,
       mingo@redhat.com
In-Reply-To: <200808182124.17359.nickpiggin@yahoo.com.au>
References: <1218880552.11912.9.camel@matrix>
	 <200808182058.07346.nickpiggin@yahoo.com.au>
	 <1219057765.10800.315.camel@twins>
	 <200808182124.17359.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Mon, 18 Aug 2008 13:51:55 +0200
Message-Id: <1219060315.10800.338.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-18 at 21:24 +1000, Nick Piggin wrote:

> Really, you think the enterprise distros will willingly break POSIX
> and their own backwards compatiblity by default? I wouldn't have
> thought so, but anyway I guess they are free to make that choice, so
> where's the problem?

I'm not seeing why you're making such a big fuss over this - IMO its not
such a significant breakage. Esp since very few realtime apps will
require such large amounts of time to ever run into the throttle.

If their usage is 95%+ cpu they must have magic WCET estamates - or like
in this case, be a benchmark app which IMHO just abuses the real-time
class.

It's like running your real-time code on a 5% slower cpu - if it runs
correctly on the 5% slower cpu, it will run correctly here too.

Note that correctness from a RT pov is making your deadline.

