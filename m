Return-Path: <linux-kernel-owner+w=401wt.eu-S1760802AbYEIEZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760802AbYEIEZS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 00:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756730AbYEIEY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 00:24:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33611
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756396AbYEIEY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 00:24:57 -0400
Date: Thu, 08 May 2008 21:24:52 -0700 (PDT)
Message-Id: <20080508.212452.236396317.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.10.0805081848170.2940@woody.linux-foundation.org>
References: <20080508.171408.94456716.davem@davemloft.net>
	<alpine.LFD.1.10.0805081848170.2940@woody.linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 8 May 2008 18:51:08 -0700 (PDT)

> David, you need to stop sending patches like this after -rc1.
> 
> This is too big. I'm taking it, but there's something wrong in this. Your 
> merges after -rc1 have generally been way too large, and I need to shut 
> you down if this gets to be a big pattern.
> 
> It's one thing taking a totally new driver (that couldn't have worked 
> before and cannot be a regression) or adding new PCI ID's. It's a totally 
> different thing to take 800 lines of code to an old driver that people 
> depend on. These things need to happen during the merge window, and just 
> because they are drivers doesn't mean that they can just do anythign they 
> want.

I saw that e1000e commit from Jeff's tree and was about to push
back on him.  But I decided not to.

I will next time if it's such a big deal, but frankly I thought this
one was OK.  It's stupid to make people wait until 2.6.27 to be able
to use the e1000e cards with the new PHY type.  It causes some hw bug
workaround to need to be added to the e1000e driver, and that's where
the bulk of that 800 line change is from.

Distributions are going to add that e1000e PHY support patch anyways,
regardless of what we do, and isn't that one of the reasons we were
talking about more aggressively merging new drivers?

Who the heck are we kidding if we don't put changes like that into the
tree when pretty much every distribution will?  Yes, even after rc1.

