Return-Path: <linux-kernel-owner+w=401wt.eu-S933738AbYEVAOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933738AbYEVAOa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 20:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757710AbYEVAOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 20:14:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44399 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756729AbYEVAOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 20:14:20 -0400
Date: Thu, 22 May 2008 01:14:12 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Cyrill Gorcunov <gorcunov@gmail.com>,
       rdunlap@xenotime.net, tytso@mit.edu, hch@infradead.org,
       linux-kernel@vger.kernel.org, davem@davemloft.net,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: CFD: linux-wanking@vger.kernel.org (was [PATCH] Standard
	indentation of arguments)
Message-ID: <20080522001412.GS28946@ZenIV.linux.org.uk>
References: <9a8748490805211306l50b8411ax4462be18c94ca065@mail.gmail.com> <32279.1211401651@vena.lwn.net> <9a8748490805211337q1e7ceab7i80e4820c46f8171b@mail.gmail.com> <9a8748490805211646s5ef93f8ey43ebbc7746fb1a3b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a8748490805211646s5ef93f8ey43ebbc7746fb1a3b@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 01:46:28AM +0200, Jesper Juhl wrote:

0.  Use your common sense.  No hard rules will ever replace that.

> - Sign up with Coverity (http://www.coverity.com/) to get access to
> the results of their regular runs of Coverity Prevent against the
> kernel source. Their static analysis of the kernel source finds many
> bugs that need fixing. There is lots of good work there that needs
> doing.
> 
> Naturally there's also other work that can be done, like writing a
> driver for some, currently unsupported, hardware etc, but its probably
> best to get your feet wet with some bug fixing first.

If you are familiar with C, reading the kernel source (e.g. starting
at system call and going down from there) can be very useful; you will
need such skills anyway and you might actually find real bugs.

Asking the questions along the lines "code seems to assume that <this> never
happens; why can't it happen and what happens if it does?" is generally
welcome, assuming that question is more or less coherent.  "I do not
understand this code at all" will be less useful and "<this> is <expletives>
BROKEN!!!  I've found a major hole!!!" would better be right - which is not
impossible.  Use common sense; if you turn out to be wrong (which is also
quite possible), the size of crow you'll have to eat will be directly
proportional to the vehemence of the original posting.  That applies to all
of us - pretty much everyone had been there and probably will be there again
and again.  On the other hand, do not be surprised if the answer will be
"It's because...  Umm...  Oh, !@#!@#, looks like you've spotted a nasty hole".
It also happens and assuming that code is correct just because it is in the
tree is a bad mistake.  Newbies can and do find serious bugs and doing that
can earn one a lot of good will.

> Try to stay away from doing pointless work, like just fixing up the
> coding style in a file, reformatting comments etc - it's not worth the
> effort and your patch is likely to be rejected. Fixing up incorrect
> comments to be correct, fixing up references to removed or renamed
> functions/arguments etc is, however, useful and worth doing.

Note that fixing up coding style in the code you are modifying is fine,
provided that coding style part does not obscure the real changes you
are making and the scale of coding style changes is not wildly out of
proportion.  Again, use the common sense - changing two lines in a function
is not a reason to reformat every file in directory while you are at it.
