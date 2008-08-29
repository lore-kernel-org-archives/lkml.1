Return-Path: <linux-kernel-owner+w=401wt.eu-S1759754AbYH2We3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759754AbYH2We3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 18:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756199AbYH2WeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 18:34:18 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:37027 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755708AbYH2WeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 18:34:18 -0400
Message-ID: <48B87960.706@garzik.org>
Date: Fri, 29 Aug 2008 18:34:08 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       David Witbrodt <dawitbro@sbcglobal.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers <kernel-testers@vger.kernel.org>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org> <200808291913.26585.rjw@sisk.pl> <200808292157.24179.rjw@sisk.pl>
In-Reply-To: <200808292157.24179.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> Bisection turned up commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd as the culprit:
> 
> commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
> Author: Yinghai Lu <yhlu.kernel@gmail.com>
> Date:   Mon Aug 25 00:56:08 2008 -0700
> 
>     x86: fix HPET regression in 2.6.26 versus 2.6.25, check hpet against BAR, v3
> 
> Reverting this commit helps.
> 
> The symptom is that AHCI probe fails with this commit applied.


Just to be sure...  Does "helps" imply that unresolved AHCI behavior 
exists after reverting that commit?

Thanks,

	Jeff



