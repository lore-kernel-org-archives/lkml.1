Return-Path: <linux-kernel-owner+w=401wt.eu-S1752713AbXEXUC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbXEXUC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 16:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750818AbXEXUCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 16:02:50 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44350 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbXEXUCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 16:02:48 -0400
Subject: Re: [2/3] 2.6.22-rc2: known regressions v2
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Cherwin R. Nooitmeer" <cherwin@gmail.com>,
       Kristian =?ISO-8859-1?Q?H=F8gsberg?= <krh@bitplanet.net>,
       Mikael Pettersson <mikpe@it.uu.se>, Pavel Machek <pavel@ucw.cz>,
       sparclinux@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       linux-usb-devel@lists.sourceforge.net, Alan Cox <alan@redhat.com>,
       linux-pm@lists.linux-foundation.org,
       Christoph Lameter <clameter@sgi.com>,
       Robert de Rooy <robert.de.rooy@gmail.com>, Tejun Heo <htejun@gmail.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-pcmcia@lists.infradead.org, Marcus Better <marcus@better.se>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Greg Kroah-Hartman <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrey Borzenkov <arvidjaar@mail.ru>,
       David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.0.98.0705241247540.26602@woody.linux-foundation.org>
References: <46558708.2040803@googlemail.com>
	 <46559B54.80106@googlemail.com>
	 <Pine.LNX.4.64.0705241001040.28086@schroedinger.engr.sgi.com>
	 <alpine.LFD.0.98.0705241007290.26602@woody.linux-foundation.org>
	 <20070524193740.GA6787@elte.hu>
	 <alpine.LFD.0.98.0705241247540.26602@woody.linux-foundation.org>
Content-Type: text/plain
Date: Thu, 24 May 2007 16:02:39 -0400
Message-Id: <1180036959.8303.130.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-17.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-24 at 12:50 -0700, Linus Torvalds wrote:
> There's a huge difference between "You killed my father, prepare to
> die", and "Btw, I didn't like that, but I'll just continue".

There are three cases, not two:

1. Something slightly suboptimal happened. We didn't like it.
2. Something very broken happened but we can recover so there's no
   need to actually commit Harikiri right now.
3. Oh fuck.

We are currently using WARN_ON() for both of the first two; I think Ingo
is merely suggesting that we start to differentiate between them. Which
makes a certain amount of sense.

-- 
dwmw2

