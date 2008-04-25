Return-Path: <linux-kernel-owner+w=401wt.eu-S1763475AbYDYUHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763475AbYDYUHu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 16:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759865AbYDYUHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 16:07:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56146
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759703AbYDYUHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 16:07:40 -0400
Date: Fri, 25 Apr 2008 13:07:39 -0700 (PDT)
Message-Id: <20080425.130739.121044720.davem@davemloft.net>
To: mingo@elte.hu
Cc: peterz@infradead.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk, alan@lxorguk.ukuu.org.uk, tglx@linutronix.de
Subject: Re: [git pull] scheduler/misc fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080425105149.GA11227@elte.hu>
References: <1209109710.7115.400.camel@twins>
	<1209118778.7115.417.camel@twins>
	<20080425105149.GA11227@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 25 Apr 2008 12:51:49 +0200

> I.e. i'd pretty much concur with you that the best solution is the very 
> first patch - which is also in the pull to Linus - we just now 
> understand exactly why ;-) David, do you agree?

I just want my machines working, so I wrapped all sparc64 IPI
calls in irq_{enter,exit}() and pushed that to Linus.
