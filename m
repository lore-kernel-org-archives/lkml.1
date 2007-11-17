Return-Path: <linux-kernel-owner+w=401wt.eu-S1763373AbXKQTlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763373AbXKQTlQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 14:41:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762710AbXKQTk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 14:40:59 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:40580 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758857AbXKQTk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 14:40:59 -0500
Date: Sat, 17 Nov 2007 20:42:40 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@tglx.de
Subject: Re: [patch] Printk kernel version in WARN_ON
Message-ID: <20071117194240.GD8568@uranus.ravnborg.org>
References: <20071117101552.2a7f34cb@laptopd505.fenrus.org> <20071117102720.251107d7.akpm@linux-foundation.org> <20071117103947.5b2052f8@laptopd505.fenrus.org> <20071117104652.8240af62.akpm@linux-foundation.org> <20071117113501.5e3e0d43@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071117113501.5e3e0d43@laptopd505.fenrus.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 17, 2007 at 11:35:01AM -0800, Arjan van de Ven wrote:
> On Sat, 17 Nov 2007 10:46:52 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > by ... not too much at least, gcc ought to be quite good at merging
> > > same-strings into one, so it's just one extra pointer argument
> > > 
> > 
> > I think I knew that.  At 1000 callsites.
> 
> ok so how about putting the same into dump_stack() instead? (see below)
> added bonus is that it's now present for all dumps that use
> dump_stack(), not just WARN_ON()
> (the format I copied from the exact line used by oopses)

This solved the "zillion files being rebuild" issue I mentioned.
So from that angle it is better.

And I notice you use the namespace aware helpers to access the
kernelrelease string - I assume this is better than direct use
of UTS_RELEASE.

	Sam
