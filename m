Return-Path: <linux-kernel-owner+w=401wt.eu-S1756995AbZEDOUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995AbZEDOUk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 10:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361AbZEDOUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 10:20:32 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:45864 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbZEDOUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 10:20:31 -0400
Date: Mon, 4 May 2009 10:10:13 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Tejun Heo <htejun@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, thomas.pi@arcor.dea,
       Yuriy Lalym <ylalym@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ltt-dev@lists.casi.polymtl.ca
Subject: Re: [PATCH] Fix dirty page accounting in
 redirty_page_for_writepage()
In-Reply-To: <49FD040B.4040705@gmail.com>
Message-ID: <alpine.DEB.1.10.0905041009140.17937@qirst.com>
References: <20090429232546.GB15782@Krystal> <alpine.LFD.2.00.0904291701450.22156@localhost.localdomain> <20090430024303.GB19875@Krystal> <20090430062140.GA9559@elte.hu> <49FD040B.4040705@gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 May 2009, Tejun Heo wrote:

> One problem I have with the above api is that those take the variable
> symbol not pointer to it, so they can't be used with dynamic
> variables.  The api needs major revisions anyway regarding atomicity

Thanks. I missed making that point.
