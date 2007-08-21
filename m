Return-Path: <linux-kernel-owner+w=401wt.eu-S1755019AbXHUIRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019AbXHUIRk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 04:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751101AbXHUIRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 04:17:30 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:42128 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbXHUIR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 04:17:29 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [accounting regression since rc1]  scheduler updates
Date: Tue, 21 Aug 2007 10:17:02 +0200
User-Agent: KMail/1.9.7
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Jan Glauber <jang@linux.vnet.ibm.com>, heiko.carstens@de.ibm.com,
       Paul Mackerras <paulus@samba.org>
References: <20070812163225.GA11996@elte.hu> <200708141037.48001.borntraeger@de.ibm.com> <20070820154529.GA300@elte.hu>
In-Reply-To: <20070820154529.GA300@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708211017.02998.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 20. August 2007 schrieb Ingo Molnar:
> could you send that precise sched_clock() patch? It should be an order 
> of magnitude simpler than the high-precision stime/utime tracking you 
> already do, and it's needed for quality scheduling anyway.

I have a question about that. I just played with sched_clock, and even when I 
intentionally slow down sched_clock by a factor of 2, my cpu bound process 
gets 100 % in top. If this is intentional, I dont understand how a 
virtualized sched_clock would fix the accounting change?

Thanks

Christian
