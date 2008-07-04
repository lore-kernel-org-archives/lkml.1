Return-Path: <linux-kernel-owner+w=401wt.eu-S1756501AbYGDBsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501AbYGDBsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 21:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756072AbYGDBsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 21:48:17 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:57179 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755092AbYGDBsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 21:48:16 -0400
Date: Thu, 3 Jul 2008 21:47:05 -0400
From: Theodore Tso <tytso@mit.edu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: David Miller <davem@davemloft.net>, jeff@garzik.org, hugh@veritas.com,
       akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
       mchan@broadcom.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org
Subject: Re: [bug?] tg3: Failed to load firmware "tigon/tg3_tso.bin"
Message-ID: <20080704014705.GM30506@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	David Woodhouse <dwmw2@infradead.org>,
	David Miller <davem@davemloft.net>, jeff@garzik.org,
	hugh@veritas.com, akpm@linux-foundation.org,
	kosaki.motohiro@jp.fujitsu.com, mchan@broadcom.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	netdev@vger.kernel.org
References: <1215093175.10393.567.camel@pmac.infradead.org> <20080703173040.GB30506@mit.edu> <1215111362.10393.651.camel@pmac.infradead.org> <20080703.162120.206258339.davem@davemloft.net> <20080704001855.GJ30506@mit.edu> <486D783B.6040904@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486D783B.6040904@infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2008 at 02:09:15AM +0100, David Woodhouse wrote:
> But there's no need to do it _now_. It can wait until the basic stuff is  
> in Linus' tree and it can automatically derive from that. There's no  
> particular rush, is there?

The only rush if the main agenda is to extirpate all firmware from the
mainline kernel sources.  I don't think we can start the timer for
doing that until the firmware tarball is created and it starts being
used as the default way of delivering firmware for what you call
"legacy" drivers.  If there's no particular rush to finally rm the
firmware for trivers such as tg3 from the source tree (and I
personally don't think there should be any rush), or any rush to
change the default for CONFIG_FIRMWARE_IN_KERNEL to "no", then I don't
see any rush in creating the firmware tarball.  

If *you* think there is a rush in making CONFIG_FIRMWARE_IN_KERNEL
default to "no", then you might want to decide to create the firmware
tarball sooner, and get distro's everywhere to start using it, and to
get everyone to understand that they should start including it in
their systems.  (Remember, not everyone uses the popular distributions
like Fedora, Debian, Ubuntu, Open SuSE, etc.)

But heck, that's up to you.  :-)

>> and for a while (read: at least 9-18 months) we can distribute firmware
> > both in the kernel source tarball as well as separately
>
> That makes a certain amount of sense.

Glad we agree.

>> in the licensing-religion-firmware tarball. 
>
> Please don't be gratuitously offensive, Ted. It's not polite, and it's  
> not a particularly good debating technique either. I expect better from 
> you.

Well, I think it's offensive to break users who have happily been
using drivers that have been including firmware for a long, long, LONG
time, and I expected better of you.

So there.  :-)

						- Ted
