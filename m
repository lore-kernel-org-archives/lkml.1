Return-Path: <linux-kernel-owner+w=401wt.eu-S1757519AbZEDO7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519AbZEDO7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 10:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbZEDO7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 10:59:21 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:35072 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbZEDO7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 10:59:21 -0400
Date: Mon, 4 May 2009 10:48:28 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, thomas.pi@arcor.dea,
       Yuriy Lalym <ylalym@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ltt-dev@lists.casi.polymtl.ca, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] Fix dirty page accounting in
 redirty_page_for_writepage()
In-Reply-To: <20090502090351.GA10159@elte.hu>
Message-ID: <alpine.DEB.1.10.0905041013550.10044@qirst.com>
References: <20090430154255.GA3714@elte.hu> <alpine.DEB.1.10.0904301142140.4028@qirst.com> <20090430160606.GA5913@elte.hu> <alpine.LFD.2.00.0904300914110.3395@localhost.localdomain> <20090430172341.GA11865@elte.hu> <alpine.DEB.1.10.0904301406210.11923@qirst.com>
 <20090501195941.GA28264@elte.hu> <alpine.DEB.1.10.0905011632440.16255@qirst.com> <20090501210724.GB11095@elte.hu> <alpine.DEB.1.10.0905012234480.32364@qirst.com> <20090502090351.GA10159@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 May 2009, Ingo Molnar wrote:

> heh, had i not asked for that during review i would have been
> drowned by Linus later on. So it was a basic survival reflex really

There seemed to be basic agreement before on upper case being the
right solution. You were not the first to bring the issue up.

There is the weighting of the shouting effect of uppercase
vs. the alert that there are wild things going on in the percpu macros.

