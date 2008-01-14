Return-Path: <linux-kernel-owner+w=401wt.eu-S1755469AbYANDuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbYANDuH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 22:50:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754299AbYANDt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 22:49:57 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:3525 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754275AbYANDt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 22:49:56 -0500
Date: Mon, 14 Jan 2008 04:49:48 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Sam Ravnborg <sam@ravnborg.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: kconfig: support option env="" [Was: kconfig: use $K64BIT to
 set 64BIT with all*config targets]
In-Reply-To: <20080106132601.GA3139@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0801140442420.17507@scrub.home>
References: <20071110204038.GA13140@uranus.ravnborg.org>
 <11947274093185-git-send-email-sam@ravnborg.org> <11947274091127-git-send-email-sam@ravnborg.org>
 <Pine.LNX.4.64.0711142116500.1818@scrub.home> <20071114220840.GB10920@uranus.ravnborg.org>
 <Pine.LNX.4.64.0711151616330.1817@scrub.home> <20080106132601.GA3139@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 6 Jan 2008, Sam Ravnborg wrote:

> Please get back to me so we can finsih this patch and have it applied.
> I will split the patch in two btw.

I reworked the patch a little and split it into three.

> > +	if (sym->flags & SYMBOL_AUTO)
> > +		sym->flags &= ~SYMBOL_WRITE;
> > +
> 
> Why is this change needed?
> It is non-obvious to me so please explain and I will add a comment.

Automatically generated symbols are not saved, this was previously not 
needed as they weren't in the menu structure.

> I did it like this:
> 			menu_warn(current_entry,
> 			          "config %s: redefining environment symbol from '%s' to '%s'",
> 			          sym->name, env, sym2->name);

I omitted the prefix, it's inconsistent with other warnings.

bye, Roman
