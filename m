Return-Path: <linux-kernel-owner+w=401wt.eu-S965578AbXIBLuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965578AbXIBLuh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 07:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965029AbXIBLua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 07:50:30 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:60955 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964901AbXIBLu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 07:50:29 -0400
Date: Sun, 2 Sep 2007 13:51:50 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Rob Landley <rob@landley.net>, Jan Engelhardt <jengelh@computergmbh.de>,
       linux-kernel@vger.kernel.org
Subject: Re: kconfig/kbuild rewite (Re: What's up with CONFIG_BLK_DEV?)
Message-ID: <20070902115150.GB30207@uranus.ravnborg.org>
References: <200708241517.28475.rob@landley.net> <Pine.LNX.4.64.0708242234250.28540@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0708242234500.28540@fbirervta.pbzchgretzou.qr> <200708260108.28584.rob@landley.net> <E1IRcvF-0007yi-73@flower>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IRcvF-0007yi-73@flower>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 02, 2007 at 02:02:37AM +0200, Oleg Verych wrote:
> * Sun, 26 Aug 2007 01:08:28 -0500
> * Organization: Boundaries Unlimited
> >
> []
> > Also "here's a symbol, show me a menu containing everything else that is 
> > either required by or enabled by this symbol..."  That sounds like a more 
> > powerful abstraction, since the previous one is "show me everything that 
> > depends on CONFIG_BLOCK".
> >
> > (I wonder if this would be a largeish rewrite of the menuconfig 
> > infrastructure?  Hmmm...)
> 
> Yess. I'm doing this, actually. Sam, Andrew and Linus have got an email
> half a year ago about my intent. Tried to release 2.6.20-j4f, but that
> was just a dream. Now i did some training in non-kernel related stuff and
> always catch (30k, 14k) LKML backlogs to stay in tune. Some bits i 
> get are here ftp://flower.upol.cz/Linux/info-LKML/tools/
> 
> So, ideas: UI, organization, efficiency, simplicity, etc. are welcome.
> 
> Maybe in one month i'll get something to show (base is 2.6.22).
> Imagination plays very well, the thing must be ground shaking, but i'll
> see how it will fit reality. Yours one in consideration from very
> beginning, don't bother :)
Then as now you have not yet expalined what you are trying to do.
Nevertheless I look forward for a minmal set of patches that improve
whatever you are working with.

As for Kconfig the low hanging fruits are not in the tools but in the
structure of the Kconfig files. There are a lot that can be improved
with a decent effort but nobody has stepped up doing so.
The tools could be better too but if the root problem is the structure
of the Kconfig files this is where we should focus and not on the tools.

For Kbuild I fail to see anything that demand a rewrite from a structure
view of the Kbuild files.
The Kbuild internal stuff is antoehr story - here a rewrite to a saner
language then GNU make syntax could improve hackability a lot.

	Sam
