Return-Path: <linux-kernel-owner+w=401wt.eu-S1753254AbYKQUSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbYKQUSy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 15:18:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbYKQUSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 15:18:45 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41870
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751515AbYKQUSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 15:18:44 -0500
Date: Mon, 17 Nov 2008 12:18:44 -0800 (PST)
Message-Id: <20081117.121844.56281291.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: mingo@elte.hu, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, cl@linux-foundation.org, efault@gmx.de,
       a.p.zijlstra@chello.nl
Subject: Re: [Bug #11308] tbench regression on each kernel release from
 2.6.22 -&gt; 2.6.28
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.0811171156080.18283@nehalem.linux-foundation.org>
References: <alpine.LFD.2.00.0811171147380.18283@nehalem.linux-foundation.org>
	<20081117.115258.227376348.davem@davemloft.net>
	<alpine.LFD.2.00.0811171156080.18283@nehalem.linux-foundation.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 17 Nov 2008 11:57:55 -0800 (PST)

> On Mon, 17 Nov 2008, David Miller wrote:
> > And as a result I found that wake_up() is now 4 times slower than it
> > was in 2.6.22, I even analyzed this for every single kernel release
> > till now.
> 
> ..and that's the one where you then pointed to hrtimers, and now you claim 
> that was fixed?

That was a huge increase going from 2.6.26 to 2.6.27, and has
been fixed.

The rest of the gradual release-to-release cost increase, however,
remains.

> At least I haven't seen any new analysis since then.

I will find time ot make it after I get back from Portland.
