Return-Path: <linux-kernel-owner+w=401wt.eu-S1760467AbYD2KDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760467AbYD2KDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 06:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbYD2KDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 06:03:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35306
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753468AbYD2KDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 06:03:34 -0400
Date: Tue, 29 Apr 2008 03:03:32 -0700 (PDT)
Message-Id: <20080429.030332.88897602.davem@davemloft.net>
To: tglx@linutronix.de
Cc: torvalds@linux-foundation.org, harvey.harrison@gmail.com, mingo@elte.hu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bitops: remove "optimizations"
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.10.0804291141580.3261@apollo.tec.linutronix.de>
References: <alpine.LFD.1.10.0804282038160.3261@apollo.tec.linutronix.de>
	<alpine.LFD.1.10.0804281233090.3119@woody.linux-foundation.org>
	<alpine.LFD.1.10.0804291141580.3261@apollo.tec.linutronix.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 29 Apr 2008 12:01:02 +0200 (CEST)

> The mapsize optimizations which were moved from x86 to the generic
> code in commit 64970b68d2b3ed32b964b0b30b1b98518fde388e increased the
> binary size on non x86 architectures.
> 
> Looking into the real effects of the "optimizations" it turned out
> that they are not used in find_next_bit() and find_next_zero_bit().
> 
> The ones in find_first_bit() and find_first_zero_bit() are used in a
> couple of places but none of them is a real hot path.
> 
> Remove the "optimizations" all together and call the library functions
> unconditionally.
> 
> Boot-tested on x86 and compile tested on every cross compiler I have.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Acked-by: David S. Miller <davem@davemloft.net>
