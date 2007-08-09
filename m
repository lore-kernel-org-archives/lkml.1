Return-Path: <linux-kernel-owner+w=401wt.eu-S939929AbXHINhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939929AbXHINhU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 09:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938908AbXHINhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 09:37:04 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45881 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765415AbXHINhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 09:37:02 -0400
Date: Thu, 9 Aug 2007 15:36:59 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: Andi Kleen <andi@firstfloor.org>, Chris Snook <csnook@redhat.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       schwidefsky@de.ibm.com, wensong@linux-vs.org, horms@verge.net.au,
       torvalds@osdl.org
Subject: Re: [patch] ipvs: force read of atomic_t in while loop
Message-ID: <20070809133659.GA28532@one.firstfloor.org>
References: <20070808093300.GA14530@osiris.boeblingen.de.ibm.com> <46BA30DC.20207@redhat.com> <20070809001533.GA17798@one.firstfloor.org> <200708091435.18595.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708091435.18595.mb@bu3sch.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Isn't it possible through some inline assembly trick
> that only a certain variable has to be reloaded?

A volatile cast does that already

-Andi

