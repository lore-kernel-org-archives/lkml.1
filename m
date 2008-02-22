Return-Path: <linux-kernel-owner+w=401wt.eu-S1758413AbYBVQM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758413AbYBVQM6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 11:12:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756338AbYBVQMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 11:12:47 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:44339 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754598AbYBVQMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 11:12:46 -0500
Date: Fri, 22 Feb 2008 17:12:56 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Regression [Was: Boot hang with stack protector on x86_64]
Message-ID: <20080222161256.GA1773@uranus.ravnborg.org>
References: <Xine.LNX.4.64.0802221121340.20800@us.intercode.com.au> <20080222075950.GB2660@uranus.ravnborg.org> <alpine.LFD.1.00.0802220739430.19896@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802220739430.19896@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 07:43:08AM -0800, Linus Torvalds wrote:
> 
> 
> On Fri, 22 Feb 2008, Sam Ravnborg wrote:
> >
> > This is a regression. Can you please revert this commit.
> 
> Not really. The thing is, CONFIG_CC_STACKPROTECTOR has never done anything 
> at all, now it does, and it shows that it never worked.
And this made a machine non-bootable that could boot before.

> 
> So the commit that made it do something shouldn't be reverted, but 
> CONFIG_CC_STACKPROTECTOR should be marked BROKEN, because it obviously is 
> broken right now.
> 
> But keeping the config option, and just not making it do anything is 
> misleading and wrong.
> 
> So just something like this? To make sure normal people don't enable it..
Whatever is fine with me - I hope Ingo & Co fixes the root cause soon so
we can get the right fix in.

	Sam
