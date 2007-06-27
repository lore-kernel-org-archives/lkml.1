Return-Path: <linux-kernel-owner+w=401wt.eu-S1763009AbXF0Vky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763009AbXF0Vky (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 17:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753842AbXF0Vkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 17:40:47 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:57374 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752158AbXF0Vkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 17:40:46 -0400
Date: Wed, 27 Jun 2007 23:40:39 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>,
       Russell King <rmk@arm.linux.org.uk>, Dirk@opfer-online.de,
       arminlitzel@web.de, pavel.urban@ct.cz, metan@atrey.karlin.mff.cuni.cz,
       thommycheck@gmail.com, milan@ucw.cz, patches@arm.linux.org.uk
Subject: Re: [PATCH] touchscreen support for collie (sharp zaurus sl-5500)
Message-ID: <20070627214039.GA25720@elf.ucw.cz>
References: <20070627144338.GA15584@elf.ucw.cz> <d120d5000706270913l50389090x8dbbdd5d3e4c7314@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d120d5000706270913l50389090x8dbbdd5d3e4c7314@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >+config MCP_COLLIE_TS
> >+       tristate "Touchscreen collie support"
> >+       depends on MCP_UCB1200 && INPUT && !MCP_UCB1200_TS
> >+        ---help---
> >+         Driver for touchscreen on collie - sharp sl-5500.
> >+
> 
> Can't ucb1x00-ts be modified to properly support collie hardware?
> These drivers look almost like twin brothers.

Well, we don't have non-collie hardware nearby. According to metan,
driver was written by the spec, but we can't test it on non-collie so
we are  probably breaking it. Can someone help with testing?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
