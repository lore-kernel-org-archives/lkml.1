Return-Path: <linux-kernel-owner+w=401wt.eu-S1754573AbXFKG2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbXFKG2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 02:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750830AbXFKG2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 02:28:03 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59399 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750778AbXFKG2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 02:28:00 -0400
Date: Sun, 10 Jun 2007 23:26:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Dan Williams" <dan.j.williams@intel.com>
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>,
       "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "Mariusz Kozlowski" <m.kozlowski@tuxland.pl>,
       linux-kernel@vger.kernel.org, "Neil Brown" <neilb@suse.de>,
       "Leech, Christopher" <christopher.leech@intel.com>,
       "Jeff Garzik" <jeff@garzik.org>, davem@davemloft.net,
       "Wolfgang Denk" <wd@denx.de>
Subject: Re: 2.6.22-rc4-mm1
Message-Id: <20070610232659.ceff247c.akpm@linux-foundation.org>
In-Reply-To: <e9c3a7c20706102201y536de24ft2daf8fbed066e28f@mail.gmail.com>
References: <20070606020737.4663d686.akpm@linux-foundation.org>
	<200706062132.37430.m.kozlowski@tuxland.pl>
	<20070606132439.3f59f0cf.akpm@linux-foundation.org>
	<20070606212831.GA1534@gondor.apana.org.au>
	<20070606164202.a3dcd176.akpm@linux-foundation.org>
	<Pine.LNX.4.61.0706070852580.1547@yvahk01.tjqt.qr>
	<20070607070108.GA8013@gondor.apana.org.au>
	<20070607001218.742c0ba5.akpm@linux-foundation.org>
	<e9c3a7c20706102201y536de24ft2daf8fbed066e28f@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jun 2007 22:01:34 -0700 "Dan Williams" <dan.j.williams@intel.com> wrote:

> It would be very helpful to have a clear merge path for dmaengine
> changes and the async offload api.

Yes, this needs some attention.

I'd suggest that you prepare a standalone tree for Linus to pull and we aim at
asking him to pull that for 2.6.23-rc1.

In the meanwhile I'd suggest that you get the core patch(es) out
onto the relevant lists again and cc'ed to the relevant maintainers.

Of course, good changelogging and commenting makes the review a) more
effective, b) more likely to happen and c) less work for reviewers.  The
changelog you have for 7556477664edcbe1c9a2fdf60edddfd8455d198b is nice,
but it's awfully short for a 1/4MB patch.  It tells us at a high level what
the code does, but it has nothing to say about how it does it: a high-level
design description, of you will.

Put yourself in the position of an experienced kernel developer who doesn't
know this code, and who doesn't know the hardware.  What can you do to make
their review easier and more effective?

So.  Please have a think about what you can do there, and also see what can
be done about the 312 warnings which

	perl scripts/checkpatch.pl patches/git-md-accel.patch

emits.  Then send 'em all out again (say, a week from now) and let's all just dig
in and make this thing happen?

