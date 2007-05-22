Return-Path: <linux-kernel-owner+w=401wt.eu-S1757906AbXEVWsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906AbXEVWsA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 18:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756015AbXEVWrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 18:47:53 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:56019 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756104AbXEVWrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 18:47:52 -0400
Message-ID: <46537314.4080605@garzik.org>
Date: Tue, 22 May 2007 18:47:48 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Greg KH <greg@kroah.com>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [stable] Wanted: Allow adding new device IDs during the	-stable
 cycle
References: <46533314.10206@redhat.com> <20070522184733.GA9357@kroah.com> <46533EA8.7020602@garzik.org> <20070522193538.GA885@kroah.com> <20070522220044.GB3429@sequoia.sous-sol.org>
In-Reply-To: <20070522220044.GB3429@sequoia.sous-sol.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wright wrote:
> 2) In theory new hardware can seem to work with a simple PCI ID
> update, and later we find it needs extra quirk handling or specific
> driver support.  This could mean adding buggy support for new hardware
> to -stable.  In practice, hopefully this isn't a real issue.

No need to worry about theory.  Since you are (or should be???) taking 
stuff solely from upstream, you should already know what is needed, or not.


> 3) It hasn't been a pressing issue brought to our attention until this
> thread and its predecessor earlier in the month.

Search your email archives, it has been brought more than the two times 
you cite.


> My own personal experience is each time I've needed a PCI ID update for
> new hardware it's also needed changes to the driver (read: e1000, every
> single time).  So from my perspective neither sysfs nor relaxing -stable
> rules slightly would actually help provide support for new hardware,
> but that's clearly limited experience.

e1000 is not a representative sample at all...

	Jeff


