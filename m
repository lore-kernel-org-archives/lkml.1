Return-Path: <linux-kernel-owner+w=401wt.eu-S1762229AbXHTRRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762229AbXHTRRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 13:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760777AbXHTRRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 13:17:05 -0400
Received: from ns1.suse.de ([195.135.220.2]:35066 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760310AbXHTRRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 13:17:03 -0400
To: "Felix Marti" <felix@chelsio.com>
Cc: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>, jeff@garzik.org,
       netdev@vger.kernel.org, rdreier@cisco.com, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org, David Miller <davem@davemloft.net>
Subject: Re: [ofa-general] Re: [PATCH RFC] RDMA/CMA: Allocate PS_TCPportsfrom the host TCP port space.
References: <20070819.174017.77241227.davem@davemloft.net>
	<8A71B368A89016469F72CD08050AD334018E20BE@maui.asicdesigners.com>
	<20070820094317.GA14817@2ka.mipt.ru>
	<8A71B368A89016469F72CD08050AD334018E2115@maui.asicdesigners.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 20 Aug 2007 20:10:56 +0200
In-Reply-To: <8A71B368A89016469F72CD08050AD334018E2115@maui.asicdesigners.com>
Message-ID: <p73y7g6yt3j.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Felix Marti" <felix@chelsio.com> writes:

> What I was referring to is that TSO(/LRO) have their own
> issues, some eluded to by Roland and me. In fact, customers working on
> the LSR couldn't use TSO due to the burstiness it introduces

That was in old kernels where TSO didn't honor the initial cwnd correctly, 
right? I assume it's long fixed.

If not please clarify what the problem was.

> have a look at graphics.
> Graphics used to be done by the host CPU and now we have dedicated
> graphics adapters that do a much better job...

Is your off load device as programable as a modern GPU?

> farfetched that offload devices can do a better job at a data-flow
> problem?

One big difference is that there is no potentially adverse and
always varying internet between the graphics card and your monitor.

-Andi
