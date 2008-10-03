Return-Path: <linux-kernel-owner+w=401wt.eu-S1754483AbYJCJbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbYJCJbw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 05:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbYJCJbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 05:31:43 -0400
Received: from gate.crashing.org ([63.228.1.57]:53475 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311AbYJCJbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 05:31:43 -0400
Subject: Re: [RFC/PATCH] Block device for the ISS simulator
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
In-Reply-To: <20081003083522.GB25683@infradead.org>
References: <20081003000904.0A812DDEEE@ozlabs.org>
	 <20081003083522.GB25683@infradead.org>
Content-Type: text/plain
Date: Fri, 03 Oct 2008 19:29:40 +1000
Message-Id: <1223026180.12264.174.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-03 at 04:35 -0400, Christoph Hellwig wrote:
> On Fri, Oct 03, 2008 at 10:08:42AM +1000, Benjamin Herrenschmidt wrote:
> > The ISS simulator is a simple powerpc simulator used among other things
> > for hardware bringup. It implements a simple memory mapped block device
> > interface.
> > 
> > This is a simple block driver that attaches to it. Note that the choice
> > of a major device number is fishy, though because it's a simulator and
> > not real hardware, it's not necessarily a big deal.
> 
> Please don't put in more block devices for every bloody simulator in the
> world.  Just emulated some simpler enough existing hardware.

I'm not sure I want it merged, but having it on the list "for the
record" is useful and it might be useful to get comments in case it's
terminally busted :-)

I'm trying to get ISS to implement an IDE interface in fact.

Cheers,
Ben.

