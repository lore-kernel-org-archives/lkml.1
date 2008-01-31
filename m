Return-Path: <linux-kernel-owner+w=401wt.eu-S933386AbYAaOM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933386AbYAaOM6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 09:12:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754932AbYAaOMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 09:12:50 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:57520 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752992AbYAaOMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 09:12:49 -0500
Date: Thu, 31 Jan 2008 15:12:47 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: Paul Mundt <lethal@linux-sh.org>, Dan Williams <dan.j.williams@intel.com>,
       linux-kernel@vger.kernel.org, Shannon Nelson <shannon.nelson@intel.com>,
       kernel@avr32linux.org, Francis Moreau <francis.moro@gmail.com>,
       "Vladimir A. Barinov" <vbarinov@ru.mvista.com>,
       Pierre Ossman <drzeus-list@drzeus.cx>
Subject: Re: [RFC v2 2/5] dmaengine: Add slave DMA interface
Message-ID: <20080131151247.47867e06@dhcp-252-066.norway.atmel.com>
In-Reply-To: <200801310451.03966.david-b@pacbell.net>
References: <1201630213-31900-1-git-send-email-hskinnemoen@atmel.com>
	<200801310027.25516.david-b@pacbell.net>
	<20080131084433.GA14160@linux-sh.org>
	<200801310451.03966.david-b@pacbell.net>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008 04:51:03 -0800
David Brownell <david-b@pacbell.net> wrote:
> First steps are after all followed by second steps, and often
> by third steps.  It's not "overengineering" to recognize when
> those steps necessarily have a direction.

But it might be considered overengineering to actually take those steps
when you're not sure if the direction is the right one :)

Maybe we should ask Al Viro if we can use his in-kernel XML parser and
take care of the extensibility requirements once and for all? ;-)

> In this case, that direction is "working on more hardware", so
> evaluating the interface proposal against several types of
> hardware is a good way to review it.  The hardware I referenced
> doesn't seem "fringe" to me; it's used on more Linux systems
> and by more users than the Synopsys design.  And I've seen some
> of the same issues on other DMA controllers:  priority, options
> for synchronization (e.g. after DMAREQ is signaled), and more.

Right, but can we get away with some sort of vague "I think we need to
go in _that_ direction eventually" spec for now, and just see how many
existing drivers and hardware we can support with just some basic
interfaces, and get a better idea about what we need to support the
remaining ones?

> In that vein, doesn't SuperH have DMA controllers to fit into this
> proposed interface?  I don't know about such "fringe" hardware
> myself, but it'd be good to know if this proposal is sufficient
> for the needs of drivers there.

That would indeed be good to know, and is in fact the reason why I Cc'd
Paul and Francis in the first place.

Haavard
