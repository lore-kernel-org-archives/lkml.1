Return-Path: <linux-kernel-owner+w=401wt.eu-S1752056AbXAXVip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbXAXVip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 16:38:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbXAXVip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 16:38:45 -0500
Received: from homer.mvista.com ([63.81.120.158]:65441 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbXAXVio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 16:38:44 -0500
Subject: Re: [patch 00/46] High resolution timer / dynamic tick update
From: Daniel Walker <dwalker@mvista.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
In-Reply-To: <1169673812.6905.71.camel@localhost.localdomain>
References: <20070123211159.178138000@localhost.localdomain>
	 <1169604991.19471.95.camel@imap.mvista.com>
	 <20070124070701.GA17654@elte.hu>
	 <1169631016.19471.175.camel@imap.mvista.com>
	 <1169668653.6905.49.camel@localhost.localdomain>
	 <1169671890.19471.309.camel@imap.mvista.com>
	 <1169673812.6905.71.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 24 Jan 2007 13:37:25 -0800
Message-Id: <1169674645.19471.320.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-24 at 13:23 -0800, john stultz wrote:

> Well, I suggested the kernel/time/timekeeping.c change go in last cycle,
> when you pushed your other cleanups, because that sort of large,
> move-tons-of-code patch sucks to keep out of the tree for long as it
> would surely collide with something at some point.

It wasn't too bad (I submitted it to -mm day before yesterday) two
collision one from the vsyscalls change, and another in the
CONFIG_TIME_INTERPOLATION .

Do you know of any others?


> Nonetheless, code talks, so don't let me get in the way, but I really
> think patching on top of the HRT queue is the best way forward. 

True, you might want to ACK my kernel/time/timekeeping.c patch (as a
reminder).

> Even if they revert portions, it clearly points out why your changes
> would be better, focusing the discussion, instead of just making a large
> alternate patch queue.

That hurts tho .. Cause if HRT just goes in the maintainers will assume
it's solid, plus the proponents of the code become defacto reviewers ..
So it make it an up hill battle the whole way .

Daniel

