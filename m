Return-Path: <linux-kernel-owner+w=401wt.eu-S1755084AbYHPC5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084AbYHPC5e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 22:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbYHPC5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 22:57:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43749
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751650AbYHPC5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 22:57:25 -0400
Date: Fri, 15 Aug 2008 19:57:24 -0700 (PDT)
Message-Id: <20080815.195724.238982506.davem@davemloft.net>
To: michael@ellerman.id.au
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: bug in lmb_enforce_memory_limit()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1218847582.7576.6.camel@localhost>
References: <1218713213.10673.17.camel@localhost>
	<20080815.152501.193746275.davem@davemloft.net>
	<1218847582.7576.6.camel@localhost>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Ellerman <michael@ellerman.id.au>
Date: Sat, 16 Aug 2008 10:46:22 +1000

> On Fri, 2008-08-15 at 15:25 -0700, David Miller wrote:
> > Sounds great.  Mind if I push the following to Linus?
> 
> Looks good to me.
> 
> I'll test it on Monday. I don't know if I have a system with memory
> holes to test on, but I take it you do?
> 
> I notice some of our 32-bit code is using lmb_enforce_memory_limit() to
> enforce an address limit, which is technically broken, but is probably
> fine because it doesn't need to worry about holes.

Sounds like fun :-)

> Acked-by: Michael Ellerman <michael@ellerman.id.au>

Thanks for reviewing Michael.
