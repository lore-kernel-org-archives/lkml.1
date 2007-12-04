Return-Path: <linux-kernel-owner+w=401wt.eu-S1752867AbXLDKJC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867AbXLDKJC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 05:09:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752179AbXLDKIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 05:08:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51955 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176AbXLDKIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 05:08:53 -0500
Date: Tue, 4 Dec 2007 11:08:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Giacomo Catenazzi <cate@cateee.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bugme-daemon@bugzilla.kernel.org
Subject: [Bug 9246] On 2.6.24-rc1-gc9927c2b BUG: unable to handle kernel
	paging request at virtual address 3d15b925
Message-ID: <20071204100832.GA11031@elte.hu>
References: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org> <471F8CAE.8000906@cateee.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471F8CAE.8000906@cateee.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0024]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hi,

* Giacomo Catenazzi <cate@cateee.net> wrote:

> On 2.6.24-rc1-gc9927c2b BUG: unable to handle kernel paging request at 
> virtual address 3d15b925
> 
> In last git, I see the following BUGs in various programs.  It seems 
> reproducible, but sometime I've hard lookup on poweroff.

do you still get this with more recent kernels? We had a number of fixes 
for memory corruptors since -rc1 - perhaps one of them took care of your 
problem as well.

	Ingo
