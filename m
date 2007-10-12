Return-Path: <linux-kernel-owner+w=401wt.eu-S1754235AbXJLBAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235AbXJLBAS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 21:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbXJLBAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 21:00:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47903
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753463AbXJLBAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 21:00:01 -0400
Date: Thu, 11 Oct 2007 17:59:50 -0700 (PDT)
Message-Id: <20071011.175950.07645359.davem@davemloft.net>
To: shemminger@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, heiko.carstens@de.ibm.com,
       schwidefsky@de.ibm.com
Subject: Re: [PATCH net-2.6.24] remove bogus qeth type check
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071011175224.130fb2f7@freepuppy.rosehill>
References: <20071011132458.3b536662@freepuppy.rosehill>
	<20071011.172454.116363992.davem@davemloft.net>
	<20071011175224.130fb2f7@freepuppy.rosehill>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@linux-foundation.org>
Date: Thu, 11 Oct 2007 17:52:24 -0700

> On Thu, 11 Oct 2007 17:24:54 -0700 (PDT)
> David Miller <davem@davemloft.net> wrote:
> 
> > With the way you set up headerops in the driver, the only way
> > to preserve the ARPHRD_IEEE802_TR guard, is to keep the
> > test that you added to qeth_hard_header_parse().
 ...
> 
> Dave, you right, that is why I put that test in. Should have kept
> the staging tree and notes around longer.

Thanks for confirming.
