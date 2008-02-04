Return-Path: <linux-kernel-owner+w=401wt.eu-S1753090AbYBDLhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090AbYBDLhM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 06:37:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563AbYBDLhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 06:37:00 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53319 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbYBDLg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 06:36:59 -0500
Subject: Re: 2.6.24-git4+ regression
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080204111747.GB4450@ics.muni.cz>
References: <20080130135609.GA5100@ics.muni.cz>
	 <20080131102919.GC27157@elte.hu>  <20080204111747.GB4450@ics.muni.cz>
Content-Type: text/plain
Date: Mon, 04 Feb 2008 12:36:36 +0100
Message-Id: <1202124997.32654.78.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-02-04 at 12:17 +0100, Lukas Hejtmanek wrote:
> Ingo,
> 
> any progress here? I've tried to revert this patch:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=67e9fb2a39a1d454218d50383094940982be138f
> 
> as it was marked as suspicious patch in this case
> (http://www.uwsg.indiana.edu/hypermail/linux/kernel/0801.3/1665.html)
> 
> but in such a case, kernel 2.6.24-git13 does oops at startup in sched_slice.
> 
> I think this is really *big* regression in 2.6.24 kernel.

I can't reproduce this with a pure cpu load. I started 10 
  while :; do :; done &
instances and aside from slowing down, nothing bad happened.

May I suggest you try latency top to see if there is something in your
build scenario that generates horrible latencies (some IO path or
whatnot).

