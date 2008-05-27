Return-Path: <linux-kernel-owner+w=401wt.eu-S1756147AbYE0C22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbYE0C22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 22:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753422AbYE0C2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 22:28:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60717
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753288AbYE0C2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 22:28:16 -0400
Date: Mon, 26 May 2008 19:28:12 -0700 (PDT)
Message-Id: <20080526.192812.184590464.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: linux-arch@vger.kernel.org, scottwood@freescale.com,
       linuxppc-dev@ozlabs.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       tpiepho@freescale.com
Subject: Re: MMIO and gcc re-ordering issue
From: David Miller <davem@davemloft.net>
In-Reply-To: <1211854540.3286.42.camel@pasglop>
References: <1211852026.3286.36.camel@pasglop>
	<20080526.184047.88207142.davem@davemloft.net>
	<1211854540.3286.42.camel@pasglop>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Tue, 27 May 2008 12:15:40 +1000

> Some of them. USB comes to mind. I'd be happy to make it "the rule" and
> document that MMIO vs. coherent access aren't implicitely ordered. I
> would still keep them ordered on powerpc for a little while tho until
> I'm happy enough with driver auditing.
> 
> But heh, it's you who was telling me that it would be a bad engineering
> decision and we had to make everybody look like x86 & fully ordered :-)
> I decided to agree back then and stuck all those nasty heavy barriers
> in the powerpc variants of readl/writel/...

I still believe this.

It's just another complicated thing for driver authors to get wrong.
The other side of the coin is of course the cost.

The only thing I am absolutely sure of is that we should make a
decision fast, document it, and just stick to it.
