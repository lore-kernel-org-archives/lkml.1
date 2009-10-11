Return-Path: <linux-kernel-owner+w=401wt.eu-S1758799AbZJKKit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799AbZJKKit (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 06:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757603AbZJKKir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 06:38:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52261
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756955AbZJKKiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 06:38:46 -0400
Date: Sun, 11 Oct 2009 03:38:42 -0700 (PDT)
Message-Id: <20091011.033842.58792773.davem@davemloft.net>
To: mb@bu3sch.de
Cc: johannes@sipsolutions.net, hidave.darkstar@gmail.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       linux-wireless@vger.kernel.org
Subject: Re: NOHZ: local_softirq_pending 08
From: David Miller <davem@davemloft.net>
In-Reply-To: <200910111217.31883.mb@bu3sch.de>
References: <20091011095217.GA2200@darkstar>
	<1255255735.4095.53.camel@johannes.local>
	<200910111217.31883.mb@bu3sch.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Buesch <mb@bu3sch.de>
Date: Sun, 11 Oct 2009 12:17:30 +0200

> On Sunday 11 October 2009 12:08:55 Johannes Berg wrote:
>> On Sun, 2009-10-11 at 17:52 +0800, Dave Young wrote:
>> 
>> FWIW, I believe the bug to be in b43 and wl12x1, and not as Michael
>> thinks in the stack.
> 
> If mac80211 requires BHs disabled, it should do this.

That's overhead, and %99 of drivers do not require it, and therefore
for %99 of drivers it's unnecessary overhead.

In general we avoid doing things like that.  Instead, we put the
cost only where it's actually needed.
