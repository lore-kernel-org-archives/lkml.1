Return-Path: <linux-kernel-owner+w=401wt.eu-S1751837AbXBFMZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837AbXBFMZR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 07:25:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751741AbXBFMZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 07:25:17 -0500
Received: from colin.muc.de ([193.149.48.1]:3120 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698AbXBFMZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 07:25:16 -0500
Date: 6 Feb 2007 13:25:14 +0100
Date: Tue, 6 Feb 2007 13:25:14 +0100
From: Andi Kleen <ak@muc.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Zachary Amsden <zach@vmware.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 0/11] VMI / Paravirt bugfixes for 2.6.21
Message-ID: <20070206122514.GA47229@muc.de>
References: <200702060352.l163q87K000713@zach-dev.vmware.com> <1170736029.29293.31.camel@localhost.localdomain> <45C809F9.2090905@vmware.com> <1170738676.29293.35.camel@localhost.localdomain> <1170752856.7324.5.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170752856.7324.5.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> hmm stolen time could even be useful without virtualization; to a large
> degree, if cpufreq reduces the speed of your cpu you have "stolen
> cycles" that way... I wonder if this concept can be used for that as
> well...

If you mean it for the real time clock: Doesn't make sense then 
because Linux time isn't measured in cycles

If you mean it for the scheduler: it only uses estimates for
relative fairness. As long as everybody is sloeed down in the same
way the relative fairness doesn't change.

For time accounting: the regular timer interrupt is fairly imprecise
anyawys because it samples at a low frequency. While it would be possible to 
improve this it would be quite costly by slowing down interrupts and syscalls.
I'm not sure it makes that much difference here either.

I don't see the point, frankly.

-Andi
