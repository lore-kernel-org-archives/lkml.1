Return-Path: <linux-kernel-owner+w=401wt.eu-S932659AbXBEQ6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932659AbXBEQ6o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 11:58:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932451AbXBEQ6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 11:58:42 -0500
Received: from smtp.osdl.org ([65.172.181.24]:49492 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838AbXBEQ6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 11:58:40 -0500
Date: Mon, 5 Feb 2007 08:58:10 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
In-Reply-To: <20070205163152.GA2464@elte.hu>
Message-ID: <Pine.LNX.4.64.0702050852160.8424@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org>
 <20070205084523.GA21858@elte.hu> <1170682488.29759.795.camel@pmac.infradead.org>
 <20070205155627.GA8354@elte.hu> <1170692539.29759.856.camel@pmac.infradead.org>
 <20070205162635.GA755@elte.hu> <20070205163152.GA2464@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 Feb 2007, Ingo Molnar wrote:
> 
> but this is /only/ practical if all (even disabled) features are visible 
> (and selectable) in the tools. They are not at the moment, so selects 
> are quite useful.

More importantly, some things that *are* visible probably shouldn't be, or 
should perhaps only be in expert mode (aka "EMBEDDED").

A prime example of this is all the firewall settings. I'd personally 
prefer to just select a "default firewall setup" which would be enough 
for all the normal crud, instead of seeing 50 different choices. 

And dammit, I'm supposed to be "technical". So if _I_ find it irritating 
to have to select all those NF_MATCH_xxx/NF_TARGET_xxx crud things, 
imagine what most people must feel like?

Me, I'd like to say I want "default firewall built in", and not have to 
see *any* of the crap. And that's exactly why "select" is a good thing.

Not using select, and have people having to say "y" to the basic feature 
and then y/m/n to each sub-feature is really damn annoying.

So thank God for the few selects we have, and we should add a whole lot 
more!

			Linus
