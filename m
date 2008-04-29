Return-Path: <linux-kernel-owner+w=401wt.eu-S1754270AbYD2Jtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbYD2Jtf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 05:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754373AbYD2JtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 05:49:24 -0400
Received: from ns2.suse.de ([195.135.220.15]:50440 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803AbYD2JtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 05:49:24 -0400
Date: Tue, 29 Apr 2008 11:50:29 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gabor Gombas <gombasg@sztaki.hu>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Solid freezes with 2.6.25
Message-ID: <20080429115029.69a8059b@strauss.suse.de>
In-Reply-To: <20080428092513.495378af.akpm@linux-foundation.org>
References: <20080428142935.GQ14074@boogie.lpds.sztaki.hu>
	<20080428092513.495378af.akpm@linux-foundation.org>
Organization: SUSE Linux Products GmbH
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton [2008-04-28 09:25]:
>
> Suspicion would have to be directed at the 2.6.25 CONFIG_HPET_EMULATE_RTC
> changes.
> 
> I think our best bet here would be to persuade someone who knows what's
> going on in there to prepare a debugging patch for you to run with
> (please).  See if we can find out what the code is doing at the time when
> it freezes up.

So the problem goes away if CONFIG_HPET_EMULATE_RTC is not set? I'm
trying to come up with a debug patch ...



	Bernhard
