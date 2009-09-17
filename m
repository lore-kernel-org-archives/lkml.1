Return-Path: <linux-kernel-owner+w=401wt.eu-S1755750AbZIQPWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750AbZIQPWk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 11:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755407AbZIQPWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 11:22:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:52852 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532AbZIQPWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 11:22:37 -0400
Subject: Re: [ofa-general] Re: [GIT PULL] please pull ummunotify
From: Peter Zijlstra <peterz@infradead.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
       general@lists.openfabrics.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <adazl8td35u.fsf@cisco.com>
References: <aday6omhz9d.fsf@cisco.com> <1253187028.8439.2.camel@twins>
	 <adafxalejiq.fsf@cisco.com> <adaab0tej5c.fsf@cisco.com>
	 <1253198976.14935.27.camel@laptop>  <adazl8td35u.fsf@cisco.com>
Content-Type: text/plain
Date: Thu, 17 Sep 2009 17:22:24 +0200
Message-Id: <1253200944.14935.29.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-17 at 08:03 -0700, Roland Dreier wrote:
> > Hmm, or are you saying you can only get 1 event per registered range and
>  > allocate the thing on registration? That'd need some registration limit
>  > to avoid DoS scenarios.
> 
> Yes, that's what I do.  You're right, I should add a limit... although
> their are lots of ways for userspace to consume arbitrary amounts of
> kernel resources already.

I'd be good to work at reducing that number, not adding to it ;-)

But yeah, I currently don't see a very nice match to perf counters.

