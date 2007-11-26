Return-Path: <linux-kernel-owner+w=401wt.eu-S1755858AbXKZRxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbXKZRxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 12:53:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752429AbXKZRxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 12:53:38 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35302 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752064AbXKZRxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 12:53:38 -0500
Date: Mon, 26 Nov 2007 09:53:17 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bron Gondwana <brong@fastmail.fm>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christian Kujau <lists@nerdbynature.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       robm@fastmail.fm
Subject: Re: [PATCH 1/1] mm: add dirty_highmem option
In-Reply-To: <20071122034204.GA14079@brong.net>
Message-ID: <alpine.LFD.0.9999.0711260949490.5869@woody.linux-foundation.org>
References: <alpine.LFD.0.9999.0711142020220.2786@woody.linux-foundation.org> <20071115052538.GA21522@brong.net> <alpine.LFD.0.9999.0711142130090.2786@woody.linux-foundation.org> <alpine.LFD.0.9999.0711142148380.2786@woody.linux-foundation.org>
 <20071115115049.GA8297@brong.net> <alpine.LFD.0.9999.0711150818320.2786@woody.linux-foundation.org> <1195155601.22457.25.camel@lappy> <1195159457.22457.35.camel@lappy> <alpine.LFD.0.9999.0711151252340.4260@woody.linux-foundation.org>
 <alpine.LFD.0.9999.0711151300250.4260@woody.linux-foundation.org> <20071122034204.GA14079@brong.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 22 Nov 2007, Bron Gondwana wrote:
> 
> This patch includes some code cleanup from Linus and a toggle in
> /proc/sys/vm/dirty_highmem which can be set to 1 to add the highmem
> back to the total available memory count.

Just to verify - can you confirm that this "just fixes it" for you?

I think this is the right approach to take, and seems very safe (ie people 
who know that their loads are ok can just set the flag), but I do want to 
verify that there was nothing else going on, and that you now see the same 
performance as you did in 2.6.16?

The other alternative, of course, would be to simply allow the dirty 
percentages to be > 100%, but that's just *odd* ;)

		Linus
