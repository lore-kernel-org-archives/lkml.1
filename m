Return-Path: <linux-kernel-owner+w=401wt.eu-S1757964AbXJ3X4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964AbXJ3X4d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 19:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbXJ3X4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 19:56:25 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60232 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbXJ3X4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 19:56:24 -0400
Date: Tue, 30 Oct 2007 16:52:02 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, akpm@linux-foundation.org,
       ak@suse.de, rajesh.shah@intel.com,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: pci-disable-decode-of-io-memory-during-bar-sizing.patch
Message-ID: <20071030165202.14651248@laptopd505.fenrus.org>
In-Reply-To: <4727C126.8070000@shaw.ca>
References: <200708151919.l7FJJfUE010966@imap1.linux-foundation.org>
	<200710251622.36773.jbarnes@virtuousgeek.org>
	<20071026025407.GA21408@kroah.com>
	<200710260959.46811.jbarnes@virtuousgeek.org>
	<20071027024140.GC29039@kroah.com>
	<47267232.3020506@shaw.ca>
	<alpine.LFD.0.999.0710300811230.30120@woody.linux-foundation.org>
	<20071030094756.779ac5c0@laptopd505.fenrus.org>
	<alpine.LFD.0.999.0710300957260.30120@woody.linux-foundation.org>
	<4727C126.8070000@shaw.ca>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2007 17:41:26 -0600
Robert Hancock <hancockr@shaw.ca> wrote:
> > I could easily see device driver writers probing to see if
> > something works, and I absolutely don't think we should just
> > automatically enable MMCONFIG from then on.
> 
> Why per device? It's not like the MSI case where both the platform
> and the device are potentially busted. Whether or not MMCONFIG works
> has nothing to do with the device, all that matters is whether it
> works on the platform. It shouldn't be the driver's responsibility to
> know this.

it's per device so that if you have have no users for this stuff,
you'll never ever get bitten by bugs (be it linux or the bios).
It's just avoiding the problem for a large class of cases... doesn't
mean it's solved for the other class, just in practice it turns it into
a much smaller problem.
