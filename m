Return-Path: <linux-kernel-owner+w=401wt.eu-S1759751AbXGPGSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759751AbXGPGSc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 02:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbXGPGSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 02:18:24 -0400
Received: from main.gmane.org ([80.91.229.2]:36879 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbXGPGSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 02:18:24 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: James Bruce <bruce@andrew.cmu.edu>
Subject: Re: [PATCH] CFS: Fix missing digit off in wmult table
Date: Mon, 16 Jul 2007 02:18:06 -0400
Message-ID: <469B0D9E.3030402@andrew.cmu.edu>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>	 <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu>	 <20070711211638.GE18767@one.firstfloor.org>	 <20070711214649.GK14435@v2.random>	 <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org>	 <Pine.LNX.4.64.0707130415520.1818@scrub.home>	 <1184302024.6709.11.camel@Homer.simpson.net>	 <Pine.LNX.4.64.0707131728070.1817@scrub.home> <1184355835.12353.321.camel@chaos>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
Cc: Roman Zippel <zippel@linux-m68k.org>, Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrea Arcangeli <andrea@suse.de>, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
X-Gmane-NNTP-Posting-Host: dhcp-7-156.dsl.telerama.com
User-Agent: Icedove 1.5.0.10 (X11/20070329)
In-Reply-To: <1184355835.12353.321.camel@chaos>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> Roman Zippel noticed inconsistency of the wmult table.
> wmult[16] has a missing digit.
[snip]

While we're at it, isn't the comment above the wmult table incorrect?
The multiplier is 1.25, meaning a 25% change per nice level, not 10%.

  - Jim

