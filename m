Return-Path: <linux-kernel-owner+w=401wt.eu-S1757635AbXJZM5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635AbXJZM5d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 08:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbXJZM51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 08:57:27 -0400
Received: from main.gmane.org ([80.91.229.2]:42906 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133AbXJZM50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 08:57:26 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Benny Amorsen <benny+usenet@amorsen.dk>
Subject: Re: IRQ off latency of printk is very high
Date: Fri, 26 Oct 2007 14:57:18 +0200
Message-ID: <m3r6jighjl.fsf@ursa.amorsen.dk>
References: <4720F21F.9090404@am.sony.com> <20071025222804.GA13954@Krystal> <47211E2C.90301@am.sony.com> <20071025231237.GT19691@waste.org> <472129C3.6040405@am.sony.com> <20071026012342.GV19691@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: hd5b9080a.c45-01-12.sta.perspektivbredband.net
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
Cancel-Lock: sha1:dkOVRNjgwgZfitDqGXJUWqiD+TE=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "MM" == Matt Mackall <mpm@selenic.com> writes:

MM> Well there are things we can do, yes, but I'd be worried that
MM> they've give up the deterministic behavior we rely on quite
MM> heavily for debugging. If event A happens before event B, we must
MM> see the message from A before the one from B, even if B happens in
MM> irq context.

MM> And if event B is a hard lock up, we'd also like to be sure the
MM> message for A actually gets out. If B happens in the interrupt
MM> that comes in when we re-enable them, that won't happen.

I can see the concerns, but right now it all leads to disabling serial
console for real-time servers. That is even less helpful for
debugging.


/Benny


