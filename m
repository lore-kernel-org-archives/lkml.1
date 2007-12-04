Return-Path: <linux-kernel-owner+w=401wt.eu-S1753596AbXLDVxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596AbXLDVxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:53:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751625AbXLDVx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:53:26 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbXLDVxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:53:25 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/linus
Cc: Shi Weihua <shiwh@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/3] signal(i386): alternative signal stack wraparound
	occurs
In-Reply-To: Ingo Molnar's message of  Tuesday, 4 December 2007 14:02:18 +0100 <20071204130218.GE31590@elte.hu>
References: <474CF7D5.6010702@cn.fujitsu.com>
	<474D05AE.60905@cn.fujitsu.com>
	<20071204130218.GE31590@elte.hu>
X-Zippy-Says: Do you guys know we just passed thru a BLACK HOLE in space?
Message-Id: <20071204215251.60C6326F8D9@magilla.localdomain>
Date: Tue,  4 Dec 2007 13:52:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Thank you for your detailed explanation and patch. I tested your 
> > patch, unfortunately it can not stop all kinds of overflow.
> [...]
> > So, the patch I posted is still needed 
> 
> thanks, i've picked up your fix for x86.git, for 2.6.25 merging.

I just explained that not all overflows would be caught and that doing so
would violate the semantics of e.g. longjmp.  I don't see how the patch
you've included now doesn't still have all those problems.  I think it's wrong.


Thanks,
Roland
