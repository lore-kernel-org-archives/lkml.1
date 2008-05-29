Return-Path: <linux-kernel-owner+w=401wt.eu-S1759680AbYE2VJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759680AbYE2VJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 17:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759400AbYE2VJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 17:09:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44746
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758973AbYE2VJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 17:09:23 -0400
Date: Thu, 29 May 2008 14:09:19 -0700 (PDT)
Message-Id: <20080529.140919.160813310.davem@davemloft.net>
To: arjan@linux.intel.com
Cc: greg@kroah.com, dwmw2@infradead.org, James.Bottomley@HansenPartnership.com,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Ksummit-2008-discuss] RFC: Moving firmware blobs out of the
 kernel.
From: David Miller <davem@davemloft.net>
In-Reply-To: <483F1232.4010003@linux.intel.com>
References: <1212077700.26088.83.camel@shinybook.infradead.org>
	<20080529164745.GA21763@kroah.com>
	<483F1232.4010003@linux.intel.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Arjan, by definition the firmware has to be tied to the kernel somehow.
THe datastructure and other aspects are often tied directly to
the firmware version loaded.

At first, people said "hey we're going to make the firmware loadable
from userspace, so sorry now you can't load your driver without a
ramdisk, sorry!"  And that royally pissed me off, and directly impacted
my work flow negatively.

Now, for the cases where we do have in-kernel firmware still, people
are suggesting to seperate that out to a seperate tree as well.
Sorry, that's taking things too far.  I've fought, like, forever, to
keep the tg3 driver with it's firmware in-tree.  I refuse to let the
driver get broken like that, it's staying working, and that means
in-tree and linked into the driver.

If debian or whoever else have these concernes and want to rip the
firmware out, it is one hundred percent their problem to patch things
out of the kernel tree they use.

At least from my perspective this looks like a transfer of burdon from
the folks who want to rip the firmware out, to those of us who find
high value in the firmware staying in the tree.

This is really irritating me, because this is one huge case of frickin
Animal Farm.  First a little was taken away, then a little bit more,
and by the end you have something absolutely nobody would have agreed
to from the beginning.
