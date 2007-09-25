Return-Path: <linux-kernel-owner+w=401wt.eu-S1760204AbXIYGMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760204AbXIYGMR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 02:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751091AbXIYGME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 02:12:04 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:44206 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803AbXIYGMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 02:12:03 -0400
Date: Tue, 25 Sep 2007 08:13:28 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: lib-y vs EXPORT_SYMBOL: who wins?
Message-ID: <20070925061328.GA10029@uranus.ravnborg.org>
References: <1190696865.27805.317.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190696865.27805.317.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2007 at 03:07:44PM +1000, Rusty Russell wrote:
> Various files under lib/ are linked into a .a so they only get linked if
> needed.  But many of these functions are also EXPORT_SYMBOL()ed.
> 
> This doesn't really make sense: if it's exported it really needs to be
> present.  Certain configurations can hit this (lguest uses kasprintf,
> and can be a module).
> 
> We could do something hacky and try to figure out if any modules need
> the symbols, which screws modules built later, but is no worse than a
> CONFIG_-based solution.
> 
> Or to we just move all the exported functions out of the .a?


I am all for killing lib-y altogether. But do not want to sacrify
kernel bloat for this.
hch suggested a bit of Kconfig tricekery and that seems
like an OK plan to me.
But I'm not in a position to do the detective work at the moment -
feed up with oter stuff for now.

	Sam
