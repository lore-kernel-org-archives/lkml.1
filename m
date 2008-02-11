Return-Path: <linux-kernel-owner+w=401wt.eu-S1757687AbYBKQf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687AbYBKQf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 11:35:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755125AbYBKQfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 11:35:16 -0500
Received: from one.firstfloor.org ([213.235.205.2]:34806 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925AbYBKQfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 11:35:15 -0500
Date: Mon, 11 Feb 2008 18:10:39 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] kgdb-light -v8, (was: Re: kgdb in git-x86#mm review)
Message-ID: <20080211171039.GA20446@one.firstfloor.org>
References: <20080211015321.GA27376@one.firstfloor.org> <y0mhcgf4ig1.fsf@ton.toronto.redhat.com> <20080211162141.GA31434@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080211162141.GA31434@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> after a quick glance i'm happy to conclude that all but one of Andi's 

At least the weird in_interrupt_stack() code seems to be still
in there.

I also still see a lot of open coded hex manipulation.

The synchronization code looks as bad as it was before.

The getthread magic pids are also still in there. What is that
good for?  

The notifiers are also still run with interrupts enabled,
so could in theory be preempted (only in some very exotic cases though)

The cpu hotplug races are still there I think

I have not rechecked everything else.

-Andi

