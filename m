Return-Path: <linux-kernel-owner+w=401wt.eu-S1763422AbXEYQXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763422AbXEYQXV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 12:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbXEYQXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 12:23:13 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:57437 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751830AbXEYQXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 12:23:12 -0400
Date: Fri, 25 May 2007 09:21:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Ingo Molnar <mingo@elte.hu>, Christoph Lameter <clameter@sgi.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Cherwin R. Nooitmeer" <cherwin@gmail.com>,
       linux-pcmcia@lists.infradead.org,
       Robert de Rooy <robert.de.rooy@gmail.com>, Alan Cox <alan@redhat.com>,
       Tejun Heo <htejun@gmail.com>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>, Mikael Pettersson <mikpe@it.uu.se>,
       linux1394-devel@lists.sourceforge.net,
       Kristian H?gsberg <krh@bitplanet.net>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Marcus Better <marcus@better.se>,
       Andrey Borzenkov <arvidjaar@mail.ru>,
       linux-usb-devel@lists.sourceforge.net,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [2/3] 2.6.22-rc2: known regressions v2
In-Reply-To: <4656B7DF.6020005@s5r6.in-berlin.de>
Message-ID: <alpine.LFD.0.98.0705250920300.26602@woody.linux-foundation.org>
References: <46558708.2040803@googlemail.com> <46559B54.80106@googlemail.com>
 <Pine.LNX.4.64.0705241001040.28086@schroedinger.engr.sgi.com>
 <alpine.LFD.0.98.0705241007290.26602@woody.linux-foundation.org>
 <20070524193740.GA6787@elte.hu> <alpine.LFD.0.98.0705241247540.26602@woody.linux-foundation.org>
 <20070525101105.GA9268@elte.hu> <4656B7DF.6020005@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 25 May 2007, Stefan Richter wrote:

> Ingo Molnar wrote:
> > i was adding WARN_ON()s that werent true 'warnings' but 'bugs'.
> 
> IME, the trace dump in the kernel log looks scary enough to be
> eventually reported, even if prefixed with "WARNING:".

Oh, absolutely. It will stand out like a sore thumb. In fact, I think 
WARNING: stands out more than BUG:, if only because it's longer!

		Linus
