Return-Path: <linux-kernel-owner+w=401wt.eu-S1761420AbYBEVS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761420AbYBEVS6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 16:18:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756854AbYBEVSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 16:18:50 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:57300 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755793AbYBEVSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 16:18:49 -0500
Date: Tue, 5 Feb 2008 22:18:54 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [git pull] x86 updates
Message-ID: <20080205211854.GB27589@uranus.ravnborg.org>
References: <20080204161219.GA8092@elte.hu> <alpine.LFD.1.00.0802051043550.9374@woody.linux-foundation.org> <20080205192236.GA26426@uranus.ravnborg.org> <20080205210508.GA14708@elte.hu> <47A8D088.7050209@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A8D088.7050209@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2008 at 01:09:28PM -0800, H. Peter Anvin wrote:
> Ingo Molnar wrote:
> >
> >btw., what's the practical consequence of getting these section flags 
> >wrong - for example writable data can end up in executable section 
> >accidentally and be marked readonly by RODATA? Or can anything more 
> >serious happen? (they cannot get into any of the discarded sections, we 
> >filter for them explicitly in the linker scripts)
> >
> 
> The practical consequences are probably zero - *except* for getting the 
> "a" flag wrong, as !a sections will never be loaded.
> 
> Technically we should also specify @progbits or @nobits on sections, 
> however, I think @progbits is the default.

I have on my todo list to do so. But I wanted to investigate a bit
more since I do not yet fully understand the difference.

And we have to use %progbits and %nobits as ARM uses '"' to indicate
comments.

	Sam
