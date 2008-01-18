Return-Path: <linux-kernel-owner+w=401wt.eu-S1759915AbYAROxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759915AbYAROxy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 09:53:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753609AbYAROxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 09:53:46 -0500
Received: from unthought.net ([212.97.129.88]:46443 "EHLO unthought.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512AbYAROxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 09:53:45 -0500
Date: Fri, 18 Jan 2008 15:53:44 +0100
From: Jakob Oestergaard <jakob@unthought.net>
To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Schwartz <davids@webmaster.com>,
       Johannes Weiner <hannes@saeurebad.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       clameter@sgi.com, penberg@cs.helsinki.fi
Subject: Re: Why is the kfree() argument const?
Message-ID: <20080118145343.GR25527@unthought.net>
Mail-Followup-To: Jakob Oestergaard <jakob@unthought.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Schwartz <davids@webmaster.com>,
	Johannes Weiner <hannes@saeurebad.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	clameter@sgi.com, penberg@cs.helsinki.fi
References: <MDEHLPKNGKAHNMBLJOLKIEGIJJAC.davids@webmaster.com> <alpine.LFD.1.00.0801171316390.14959@woody.linux-foundation.org> <20080118094826.GN25527@unthought.net> <20080118133116.GA31790@atjola.homenet>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080118133116.GA31790@atjola.homenet>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 02:31:16PM +0100, Björn Steinbrink wrote:
...
> 
> Do you see anything that casts the const away? No? Me neither. Still,
> the memory that p points to was changed, because there was another
> pointer and that was not const.

*another* being key here.

> 
> > *That* is the purpose of const pointers.
> 
> The only thing that const can tell you is that you should not modify the
> value _yourself_, using that pointer _directly_.

Which is pretty damn useful.

Think about it.  Don't you ever use const?  Is it ever only in the way?

...
{snip long explanation about how one can avoid the benefits of const, without
using casts}
...
> If you want to restrict the set of pointers that can be invalidated by
> an other pointer, you'll have to use something else because const does
> not talk about invalidating aliasing pointers.

Precisely, so why are we discussing this?

I claim that const is useful. You claim that it can't solve all the worlds
problems. I agree with that, but I maintain it is still useful.

But, in order for it to be useful, it requires that people do not circumvent it
in the wrong places (such as kfree).

-- 

 / jakob

