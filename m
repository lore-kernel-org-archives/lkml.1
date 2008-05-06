Return-Path: <linux-kernel-owner+w=401wt.eu-S933317AbYEFVBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933317AbYEFVBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 17:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761564AbYEFVBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 17:01:19 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:38261 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756121AbYEFVBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 17:01:17 -0400
Subject: Re: [PATCH] clocksource: shift helper
From: Daniel Walker <dwalker@mvista.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: akpm@linux-foundation.org, johnstul@us.ibm.com, ralf@linux-mips.org,
       anemo@mba.ocn.ne.jp, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0805062242020.3318@apollo.tec.linutronix.de>
References: <20080501173123.444094226@mvista.com>
	 <alpine.LFD.1.10.0805060250410.3318@apollo.tec.linutronix.de>
	 <1210091954.17132.142.camel@localhost.localdomain>
	 <alpine.LFD.1.10.0805061854310.3318@apollo.tec.linutronix.de>
	 <1210106014.17132.172.camel@localhost.localdomain>
	 <alpine.LFD.1.10.0805062242020.3318@apollo.tec.linutronix.de>
Content-Type: text/plain
Date: Tue, 06 May 2008 14:01:15 -0700
Message-Id: <1210107675.17132.181.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-05-06 at 22:53 +0200, Thomas Gleixner wrote:
> 
> And your description led me to the assumption that the code was pulled
> from the MIPS git tree and not from the MIPS architecture code in
> mainline. Everyone else I talked to was having the same impression.
> 
> I was wrong, but can you understand that your sloppy wording "pulled
> from the MIPS tree" along with the fact that you just copied code
> instead of moving it into the generic space and cleanup the MIPS code
> where it is duplicated from is causing such a misunderstanding ?

You could have asked me if it was mainline or not. I can see how words
could be misunderstood .

> I'm fine with the change itself, but it needs to move the code out of
> MIPS in the first place and not just duplicating code for no good
> reason.

I can work with Atsushi, but I still think the generic version should be
merged. We at least would need it in order to modify the mips code.

Daniel

