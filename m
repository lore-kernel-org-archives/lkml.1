Return-Path: <linux-kernel-owner+w=401wt.eu-S1757818AbXL3QOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757818AbXL3QOy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 11:14:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753741AbXL3QOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 11:14:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48763 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865AbXL3QOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 11:14:42 -0500
Date: Sun, 30 Dec 2007 17:14:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Mohr <andi@lisas.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>, Pavel Emelyanov <xemul@openvz.org>,
       "Denis V. Lunev" <den@openvz.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [usb regression] Re: [PATCH 2.6.24-rc3] Fix /proc/net breakage
Message-ID: <20071230161405.GA27788@elte.hu>
References: <200711192304.25087.rjw@sisk.pl> <4743026B.2020907@openvz.org> <m1hcj8mz1p.fsf_-_@ebiederm.dsl.xmission.com> <1197003097.13978.557.camel@pmac.infradead.org> <20071207022342.806ee4ee.akpm@linux-foundation.org> <20071227174056.GA17350@rhlx01.hs-esslingen.de> <20071227184145.GA1831@martell.zuzino.mipt.ru> <20071227221728.GA17379@rhlx01.hs-esslingen.de> <20071228062201.GA2071@martell.zuzino.mipt.ru> <20071228072116.GA16553@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071228072116.GA16553@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andreas Mohr <andi@lisas.de> wrote:

> (yes, that's all there is, despite CONFIG_USB_DEBUG being set)
> 
> The LED of a usb stick isn't active either, for obvious reasons.
> 
> And keep in mind that this is a (relatively old) OHCI-only machine... 
> (which had the 2.6.19 lsmod showing ohci-hcd just fine and working 
> fine with WLAN USB)
> 
> Now pondering whether to try -rc6 proper or whether to revert specific 
> guilty-looking USB changes... And wondering how to properly elevate 
> this issue (prompt Greg about it, new thread, bug #, ...?)

Cc:-ed Alan Stern for the USB regression.

	Ingo
