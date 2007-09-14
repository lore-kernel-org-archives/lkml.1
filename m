Return-Path: <linux-kernel-owner+w=401wt.eu-S1757349AbXINSSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349AbXINSSE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 14:18:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184AbXINSRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 14:17:52 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:41678 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754350AbXINSRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 14:17:51 -0400
Message-ID: <46EAD049.4020107@garzik.org>
Date: Fri, 14 Sep 2007 14:17:45 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] net driver fixes
References: <20070913053022.GA16891@havoc.gtf.org> <1189793598.2508.4.camel@xo-3E-67-34.localdomain>
In-Reply-To: <1189793598.2508.4.camel@xo-3E-67-34.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams wrote:
> WTF?  why would the default be to _not_ propagate carrier state?  Are
> there some mitigating circumstances that require this driver to not
> notify the stack of carrier on/off?  Userspace stuff really should know
> about the carrier state, and this disables it by default.


The commit explains that...

	Jeff


