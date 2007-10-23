Return-Path: <linux-kernel-owner+w=401wt.eu-S1756633AbXJWWlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633AbXJWWlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 18:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756262AbXJWWkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 18:40:14 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33171 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756216AbXJWWkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 18:40:12 -0400
Message-ID: <471E784A.5090303@garzik.org>
Date: Tue, 23 Oct 2007 18:40:10 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 11/12] NET: fix subqueue bugs
References: <tueoct232007613pm.likjasfdlkjdas987@havoc.gtf.org>	<20071023223646.550241F81B7@havoc.gtf.org> <20071023.153836.85407923.davem@davemloft.net>
In-Reply-To: <20071023.153836.85407923.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Jeff Garzik <jeff@garzik.org>
> Date: Tue, 23 Oct 2007 18:36:46 -0400 (EDT)
> 
>> net/sched/sch_prio.c: In function $,1rxprio_dequeue$,1ry:
>> net/sched/sch_prio.c:139: warning: passing argument 2 of $,1rxnetif_subqueue_stopped$,1ry makes pointer from integer without a cast
>> net/sched/sch_prio.c: In function $,1rxrr_dequeue$,1ry:
>> net/sched/sch_prio.c:169: warning: passing argument 2 of $,1rxnetif_subqueue_stopped$,1ry makes pointer from integer without a cast
>>
>> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> 
> I have another copy of this from Pavel earlier in my inbox
> and I promise I will integrate his patch today :-)

Either way, all good :)  Just dumping my fixes from last night.

	Jeff


