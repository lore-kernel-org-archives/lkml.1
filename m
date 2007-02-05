Return-Path: <linux-kernel-owner+w=401wt.eu-S1751714AbXBEQd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714AbXBEQd6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 11:33:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbXBEQd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 11:33:58 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58083 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbXBEQd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 11:33:57 -0500
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070205162635.GA755@elte.hu>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org>
	 <20070205084523.GA21858@elte.hu>
	 <1170682488.29759.795.camel@pmac.infradead.org>
	 <20070205155627.GA8354@elte.hu>
	 <1170692539.29759.856.camel@pmac.infradead.org>
	 <20070205162635.GA755@elte.hu>
Content-Type: text/plain
Date: Mon, 05 Feb 2007 16:33:51 +0000
Message-Id: <1170693231.29759.867.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-05 at 17:26 +0100, Ingo Molnar wrote:
> > I come across this frequently -- and I just look at the Kconfig file 
> > to see the dependencies of the option I want to enable. It's usually 
> > very simple.
> 
> i come across this problem frequently, and sometimes it's far from 
> simple and involves half a dozen Kconfigs. For example pick up a Fedora 
> .config of your choice and disable CONFIG_I2C.

Erm, isn't that _my_ example? I'm willing to bet that it'll take me
hours to turn _off_ CONFIG_I2C because the widespread abuse of 'select'
helpfully turning it back on again for me because I have some video
stuff, or some thermal stuff, etc. 

> > It's got a _lot_ harder recently to turn stuff _off_, as rmk observes. 
> > You don't just look at the option you're interested in; you have to 
> > grep all over the rest of the tree to find the 'select' which is 
> > forcing it on after you turn it off. It's no longer in one place.
> 
> yeah.
> 
> > > I think that by blaming Aunt Tillie you might be missing the real 
> > > problem.
> > 
> > No, by arbitrarily throwing 'select' into the mix with no real 
> > guidance as to when to use it and when to use normal dependencies, 
> > _that's_ when we're missing the real problem.
> 
> we should not have 'select' at all - unless it's some non-code option 
> that is just a convenience switch for several other config options. A 
> true dependency is already expressed in one direction via the 'depend 
> on' directive - no need to express it in the other direction as well, 
> that only leads to redundancy and to bugs.

Right.

-- 
dwmw2

