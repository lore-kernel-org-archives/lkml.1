Return-Path: <linux-kernel-owner+w=401wt.eu-S1753343AbYCYJmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbYCYJmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 05:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbYCYJmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 05:42:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55864
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751821AbYCYJmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 05:42:05 -0400
Date: Tue, 25 Mar 2008 02:42:04 -0700 (PDT)
Message-Id: <20080325.024204.175042056.davem@davemloft.net>
To: mingo@elte.hu
Cc: jirislaby@gmail.com, viro@ZenIV.linux.org.uk, joe@perches.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 109/148] include/asm-x86/serial.h: checkpatch cleanups
 - formatting only
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080325084457.GA32103@elte.hu>
References: <47E64BF7.4070808@gmail.com>
	<20080323.053037.144236584.davem@davemloft.net>
	<20080325084457.GA32103@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 25 Mar 2008 09:44:57 +0100

> * David Miller <davem@davemloft.net> wrote:
> 
> > I strongly disagree still.
> > 
> > Half the warnings I get when I have run checkpatch on things I've 
> > written were crap.
> 
> could you please give me a file name as an example that i could 
> double-check myself? Thanks,

I can't because I pacified it to cut down the review noise
for the patch in question last time it happened.

I can tell you one more example of things I strongly disagree with
that it does, for example, such as telling me how to document
spinlocks in datastructures.

It wants a comment right above the spinlock_t member, but this
totally ignores that perhaps I put a huge comment explaining
the locking semantics elsewhere.

It's a black and white tool in a grey world, it just sucks.  And I'd
be fine with that if people used it as a guide but people, especially
kernel newbies, treat it as gospel and a way to contribe "useful"
patches.  They aren't useful, they're crap.  Fix a bug instead of this
automaton whitespace noise.
