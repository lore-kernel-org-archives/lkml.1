Return-Path: <linux-kernel-owner+w=401wt.eu-S1760677AbXEYMgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760677AbXEYMgQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 08:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751820AbXEYMgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 08:36:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53205 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719AbXEYMgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 08:36:00 -0400
Date: Fri, 25 May 2007 14:34:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Chris Newport <crn@netunix.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Cherwin R. Nooitmeer" <cherwin@gmail.com>,
       linux-pcmcia@lists.infradead.org,
       Robert de Rooy <robert.de.rooy@gmail.com>, Alan Cox <alan@redhat.com>,
       Tejun Heo <htejun@gmail.com>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>, Mikael Pettersson <mikpe@it.uu.se>,
       linux1394-devel@lists.sourceforge.net,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Kristian H?gsberg <krh@bitplanet.net>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Marcus Better <marcus@better.se>,
       Andrey Borzenkov <arvidjaar@mail.ru>,
       linux-usb-devel@lists.sourceforge.net,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [2/3] 2.6.22-rc2: known regressions v2
Message-ID: <20070525123456.GA17238@elte.hu>
References: <46558708.2040803@googlemail.com> <46559B54.80106@googlemail.com> <Pine.LNX.4.64.0705241001040.28086@schroedinger.engr.sgi.com> <alpine.LFD.0.98.0705241007290.26602@woody.linux-foundation.org> <20070524193740.GA6787@elte.hu> <alpine.LFD.0.98.0705241247540.26602@woody.linux-foundation.org> <20070525101105.GA9268@elte.hu> <4656CE39.8050800@netunix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4656CE39.8050800@netunix.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Chris Newport <crn@netunix.com> wrote:

> There is a fundamental problem in getting a decent log to debug a 
> crashed kernel.  Maybe we should take a hint from Solaris. If the 
> kernel crashes Solaris dumps core to swap and sets a flag. At the next 
> boot this image is copied to /var/adm/crashdump where it is preserved 
> for future debugging. Obviously swap needs to be larger than core, but 
> this is usually the case.

we've got kdump, but it's not usually enabled by default by distros.

	Ingo
