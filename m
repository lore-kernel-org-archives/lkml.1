Return-Path: <linux-kernel-owner+w=401wt.eu-S1757303AbZAUOaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303AbZAUOaG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 09:30:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754104AbZAUO3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 09:29:52 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59036 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031AbZAUO3w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 09:29:52 -0500
Date: Wed, 21 Jan 2009 09:29:37 -0500
From: Kyle McMartin <kyle@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, Helge Deller <deller@gmx.de>,
       David Miller <davem@davemloft.net>, jaswinder@kernel.org, mingo@elte.hu,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       linux-parisc@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: Confusion in usr/include/asm-generic/fcntl.h
Message-ID: <20090121142937.GB27998@bombadil.infradead.org>
References: <1232496257.3123.19.camel@localhost.localdomain> <200901210924.23484.arnd@arndb.de> <20090121113853.GB1579@uranus.ravnborg.org> <200901211313.17394.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <200901211313.17394.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 01:13:16PM +0100, Arnd Bergmann wrote:
> On Wednesday 21 January 2009, Sam Ravnborg wrote:
> > Could we add a new symbol for this?
> > We know we are going to use this in several places so a simpler variant
> > would be more readable.
> > 
> > Something like:
> > 
> > #ifdef __64BIT
> > ...
> > #endif
> > 
> > When we define __64BIT we would use the  __BITS_PER_LONG == 64 check.
> 
> I would prefer using the __BITS_PER_LONG == 64 check directly, because
> it gives you a warning when __BITS_PER_LONG is undefined, whereas the
> #ifdef check gets easily fooled by include order problems. Note that
> this is not a problem in the kernel for CONFIG_* symbols which are
> always defined before the first #include.
> 

This is cool with me Arnd. Rock on. :)

cheers, Kyle
