Return-Path: <linux-kernel-owner+w=401wt.eu-S1757386AbYEDS0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386AbYEDS0k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 14:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754010AbYEDS0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 14:26:31 -0400
Received: from enyo.dsw2k3.info ([195.71.86.239]:46474 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbYEDS0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 14:26:30 -0400
X-Greylist: delayed 1628 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 May 2008 14:26:30 EDT
Date: Sun, 4 May 2008 19:59:13 +0200
From: Matthias Schniedermeyer <ms@citd.de>
To: Bernd Petrovitsch <bernd@firmix.at>
Cc: Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kconfig - a suggestion how to fix the select issue
Message-ID: <20080504175913.GA28072@citd.de>
References: <20080504071041.GA15315@uranus.ravnborg.org> <1209895922.4114.21.camel@gimli.at.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209895922.4114.21.camel@gimli.at.home>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.05.2008 12:12, Bernd Petrovitsch wrote:
> On Sun, 2008-05-04 at 09:10 +0200, Sam Ravnborg wrote:
> > Today we have two ways to express/solve dependencies.
> > 
> > Top-down we have "depends on"
> > and bottom up we have "select".
> > 
> > The "depends on" dependencies at the same
> > time impact the visibility of a symbol.
> > A symbol with "depends on" not satisfied are not
> > visible and thus not shown in menuconfig.
> 
> Perhaps this is problem: The menu item shouldn't be selectable for sure
> but it may well be visible (and I'm purposely ignoring details of "how
> to grey out" for the different user interfaces).
> If it's visible (but not selectable) the user interface can provide the
> auto-generated requirements (derived from the "depends on" chains) as
> part of the "help" or where ever it seems useful. And the user at least
> knows where to look further.

I always wondered why there is no "grey out", at least optionaly.

My "favourite"(tm) example of a sub-marine is: Wireless drivers (mac80211).

The config-option to switch on the visibility of the mac80211 drivers 
("CONFIG_MAC80211") is conveniently located on the other side of the 
milky way.
(3 menus down, a sitestep and 2 up again. At least in menuconfig)







Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

