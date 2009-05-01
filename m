Return-Path: <linux-kernel-owner+w=401wt.eu-S1765564AbZEAUqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765564AbZEAUqA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 16:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754670AbZEAUpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 16:45:51 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:54572 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbZEAUpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 16:45:51 -0400
Date: Fri, 1 May 2009 16:35:34 -0400 (EDT)
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
In-Reply-To: <20090501195941.GA28264@elte.hu>
Message-ID: <alpine.DEB.1.10.0905011632440.16255@qirst.com>
References: <20090430143819.GF14696@elte.hu> <alpine.DEB.1.10.0904301042170.4028@qirst.com> <20090430150142.GC20580@elte.hu> <alpine.DEB.1.10.0904301114440.4028@qirst.com> <20090430154255.GA3714@elte.hu> <alpine.DEB.1.10.0904301142140.4028@qirst.com>
 <20090430160606.GA5913@elte.hu> <alpine.LFD.2.00.0904300914110.3395@localhost.localdomain> <20090430172341.GA11865@elte.hu> <alpine.DEB.1.10.0904301406210.11923@qirst.com> <20090501195941.GA28264@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 May 2009, Ingo Molnar wrote:

> > Plus percpu_add_preemptsafe().
>
> Ok - that would be easy. Would you be interested in doing that and
> would you be interested in resurrecting your old patches? They are
> genuinely useful IMHO.

I see but it may take some time for me to get that finished (probably 2
weeks or so). Dont feel that you have to merge my old patches or a variant
thereof.
