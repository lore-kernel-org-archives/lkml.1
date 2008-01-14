Return-Path: <linux-kernel-owner+w=401wt.eu-S1752173AbYANF6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173AbYANF6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 00:58:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750864AbYANF6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 00:58:44 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:37567 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801AbYANF6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 00:58:43 -0500
Date: Mon, 14 Jan 2008 06:58:48 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: kconfig: support option env="" [Was: kconfig: use $K64BIT to set 64BIT with all*config targets]
Message-ID: <20080114055848.GA5187@uranus.ravnborg.org>
References: <20071110204038.GA13140@uranus.ravnborg.org> <11947274093185-git-send-email-sam@ravnborg.org> <11947274091127-git-send-email-sam@ravnborg.org> <Pine.LNX.4.64.0711142116500.1818@scrub.home> <20071114220840.GB10920@uranus.ravnborg.org> <Pine.LNX.4.64.0711151616330.1817@scrub.home> <20080106132601.GA3139@uranus.ravnborg.org> <Pine.LNX.4.64.0801140442420.17507@scrub.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801140442420.17507@scrub.home>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 04:49:48AM +0100, Roman Zippel wrote:
> Hi,
> 
> On Sun, 6 Jan 2008, Sam Ravnborg wrote:
> 
> > Please get back to me so we can finsih this patch and have it applied.
> > I will split the patch in two btw.
> 
> I reworked the patch a little and split it into three.

Thanks Roman.
I will test and apply tonight.

Removal of KERNELVERSION in patch #3 is wrong as the frontend
uses KERNELVERSION to display the kernel version in their title.
I will drop the deletion before I apply the patch.


> 
> > > +	if (sym->flags & SYMBOL_AUTO)
> > > +		sym->flags &= ~SYMBOL_WRITE;
> > > +
> > 
> > Why is this change needed?
> > It is non-obvious to me so please explain and I will add a comment.
> 
> Automatically generated symbols are not saved, this was previously not 
> needed as they weren't in the menu structure.
OK

> 
> > I did it like this:
> > 			menu_warn(current_entry,
> > 			          "config %s: redefining environment symbol from '%s' to '%s'",
> > 			          sym->name, env, sym2->name);
> 
> I omitted the prefix, it's inconsistent with other warnings.
OK

Thanks,
	Sam
