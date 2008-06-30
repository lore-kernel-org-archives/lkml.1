Return-Path: <linux-kernel-owner+w=401wt.eu-S933561AbYF3Wz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933561AbYF3Wz5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 18:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763763AbYF3Wzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 18:55:46 -0400
Received: from vena.lwn.net ([206.168.112.25]:53399 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762391AbYF3Wzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 18:55:45 -0400
Date: Mon, 30 Jun 2008 16:55:43 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Roland Dreier <rdreier@cisco.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
       general@lists.openfabrics.org
Subject: Re: [PATCH] IB/uverbs: BKL is not needed for ib_uverbs_open()
Message-ID: <20080630165543.1ccd8858@bike.lwn.net>
In-Reply-To: <adaskuylfk7.fsf@cisco.com>
References: <20080627095418.2353267d@bike.lwn.net>
	<adaskuylfk7.fsf@cisco.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2008 14:43:20 -0700
Roland Dreier <rdreier@cisco.com> wrote:

> Is this sort of patch the next step in the BKL-removal plan?  Is now
> an appropriate time to send such things?
> 
> If this looks good to you I will do a careful audit of the rest of
> drivers/infiniband/core and send you a few more similar patches.

That's the general idea: audit the code where the BKL appears and
remove it when it's safe to do so.  It's always an appropriate time;
the only question is whether you think this change is good to go into
the tree for 2.6.27, or whether it should hang out in linux-next for
one more cycle.  I would assume that the extra time would not be
necessary.

Thanks,

jon
