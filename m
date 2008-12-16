Return-Path: <linux-kernel-owner+w=401wt.eu-S1757009AbYLPAZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009AbYLPAZc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 19:25:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754796AbYLPAZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 19:25:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39128 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754182AbYLPAZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 19:25:24 -0500
Date: Mon, 15 Dec 2008 16:25:19 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: Alex Chiang <achiang@hp.com>, Matthew Wilcox <matthew@wil.cx>,
       Justin Chen <justin.chen@hp.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: PCI BAR mem resource allocation "regression"
In-Reply-To: <200812151204.21089.jbarnes@virtuousgeek.org>
Message-ID: <alpine.LFD.2.00.0812151623440.3237@localhost.localdomain>
References: <20081213000538.GC9947@ldl.fc.hp.com> <20081214010534.GB22302@ldl.fc.hp.com> <alpine.LFD.2.00.0812131708240.3340@localhost.localdomain> <200812151204.21089.jbarnes@virtuousgeek.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 15 Dec 2008, Jesse Barnes wrote:
> 
> I can put your patch in my -next branch if you think it would help (not that -
> next gets a ton of testing, but hey)...

Better than nothing, I guess.

We may end up back-porting it (since Chen confirms that it's not just a 
warning, it actually affects functionality), but let's get it some testing 
in -next first and then eventually in the merge window. So you might mark 
it for attention for 'stable@kernel.org' as you commit it.

		Linus
