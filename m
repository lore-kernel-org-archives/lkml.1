Return-Path: <linux-kernel-owner+w=401wt.eu-S1763655AbXJRDyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763655AbXJRDyD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 23:54:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754687AbXJRDxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 23:53:50 -0400
Received: from mail.windriver.com ([147.11.1.11]:60609 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754641AbXJRDxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 23:53:49 -0400
Message-ID: <4716D887.2020209@windriver.com>
Date: Wed, 17 Oct 2007 22:52:39 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@linux-foundation.org>
CC: "David S. Miller" <davem@davemloft.net>, Andrew Morton <akpm@osdl.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] remove netpoll receive code
References: <20071017132131.1992bedd@freepuppy.rosehill>
In-Reply-To: <20071017132131.1992bedd@freepuppy.rosehill>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Oct 2007 03:53:41.0355 (UTC) FILETIME=[78DC7BB0:01C8113A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kgdb has been submitted for inclusion in the mainline kernel at this
point, along with an additional change to the netpoll rx path.

If it is the case that this needs to be implemented in another manner,
that is ok but please do let me know what the plans are for the API so
that the kgdboe code can be adapted.

Thanks,
Jason.



Stephen Hemminger wrote:
> The netpoll receive code is:
> 1. Not used by any in-tree features, it is used by kgdb-over-ether.
> 2. A nice hook for people doing nasty things like private binary network stacks or rootkits.
> 3. Unsecured by any of the normal firewalling code.
>
> Hopefully all distro's are smart enough to turn it off in their default config *nudge, nudge*.
> Doubly true for any distribution that claims to be secure or enterprise ready.
>
> I propose that we take out all the whole netpoll rx path. If/when kgdb gets submitted
> a better and alternative receive path can be added.
>
>   

