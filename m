Return-Path: <linux-kernel-owner+w=401wt.eu-S964868AbXDEIuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964868AbXDEIuW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 04:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965084AbXDEIuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 04:50:22 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3714 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964868AbXDEIuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 04:50:21 -0400
Date: Thu, 5 Apr 2007 09:50:03 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Paul Mackerras <paulus@samba.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Theodore Tso <tytso@mit.edu>,
       "H. Peter Anvin" <hpa@zytor.com>, David Miller <davem@davemloft.net>,
       alan@lxorguk.ukuu.org.uk, flar@allandria.com, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
Message-ID: <20070405085003.GA22362@flint.arm.linux.org.uk>
Mail-Followup-To: Paul Mackerras <paulus@samba.org>,
	David Woodhouse <dwmw2@infradead.org>, Theodore Tso <tytso@mit.edu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	David Miller <davem@davemloft.net>, alan@lxorguk.ukuu.org.uk,
	flar@allandria.com, linuxppc-dev@ozlabs.org,
	linux-kernel@vger.kernel.org
References: <17939.15726.114059.679277@cargo.ozlabs.ibm.com> <1175666635.2932.17.camel@shinybook.infradead.org> <20070404.011208.120446173.davem@davemloft.net> <20070404083803.GA13134@flint.arm.linux.org.uk> <20070404122154.GF31973@thunk.org> <4613CF6A.2090407@zytor.com> <20070404174153.GI31973@thunk.org> <20070404181531.GA9388@flint.arm.linux.org.uk> <1175716215.2774.52.camel@shinybook.infradead.org> <17940.37291.211960.566580@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17940.37291.211960.566580@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 05, 2007 at 04:05:31PM +1000, Paul Mackerras wrote:
> David Woodhouse writes:
> 
> > And you always will be. The amount of pain involved in implementing
> > this, just so that people can call their serial port 'ttyS0', is _far_
> > more than it's worth. It could be done, but it's a completely pointless
> > waste of time and effort. 
> 
> Avoiding breaking userspace is a completely pointless waste of time
> and effort?  Linux is ready for the desktop?  Suuuure it is...

And what contribution to achieving the goal of having a single namespace
does the above comment provide?

Look, this is what I'm complaining about.  There's lots of talk on this
issue.  There's been lots and lots of talk on this issue in the past as
well.  I've raised the technical issues in this thread several times and
so far been ignored every time.

If as much effort went into trying to resolve the technical problems as
has gone into whinging about it in this thread, maybe the goal would be
a little closer?

I'm sorry if you find this message offensive.  I find filling my mailbox
with 80ish messages of whinging utterly unproductive and equally offensive
especially given my past input on serial issues.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
