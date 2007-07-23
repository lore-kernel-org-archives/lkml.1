Return-Path: <linux-kernel-owner+w=401wt.eu-S1763532AbXGWIXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763532AbXGWIXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 04:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754429AbXGWIXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 04:23:10 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:43381 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665AbXGWIXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 04:23:09 -0400
Date: Mon, 23 Jul 2007 10:24:23 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Roland McGrath <roland@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>, Alan Modra <amodra@bigpond.net.au>,
       David Miller <davem@davemloft.net>, Adrian Bunk <bunk@stusta.de>,
       linux-kernel@vger.kernel.org
Subject: Re: "build-id" changes break sparc64
Message-ID: <20070723082423.GC4644@uranus.ravnborg.org>
References: <20070723081435.GA4644@uranus.ravnborg.org> <20070723081814.846B64D058D@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070723081814.846B64D058D@magilla.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 01:18:14AM -0700, Roland McGrath wrote:
> > > -cmd_link_multi-m = $(LD) $(ld_flags) $(LDFLAGS_MODULE) -o $@ $(link_multi_deps)
> > > +cmd_link_multi-m = $(cmd_link_multi-y)
> > This signel change looks wrong. We do not want to generate a linker
> > script for modules.
> 
> multi-m has nothing to do with modules, really.  It's just for another
> "built-in.o"-style object that happens to be the input for a .ko link
> rather than the vmlinux link.  
OK - so even in that case we should defer to the link script trick - OK.

	Sam
