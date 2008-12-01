Return-Path: <linux-kernel-owner+w=401wt.eu-S1751337AbYLAHOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751337AbYLAHOI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 02:14:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750718AbYLAHNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 02:13:55 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51540
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750714AbYLAHNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 02:13:54 -0500
Date: Sun, 30 Nov 2008 23:13:54 -0800 (PST)
Message-Id: <20081130.231354.204449660.davem@davemloft.net>
To: viro@ZenIV.linux.org.uk
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [please, revert] Re: [PATCH 11/32] of_platform_driver noise on
 sparce
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081130212329.GF28946@ZenIV.linux.org.uk>
References: <E1L3wNs-0006R4-JQ@ZenIV.linux.org.uk>
	<20081126.010541.158438052.davem@davemloft.net>
	<20081130212329.GF28946@ZenIV.linux.org.uk>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Sun, 30 Nov 2008 21:23:29 +0000

> On Wed, Nov 26, 2008 at 01:05:41AM -0800, David Miller wrote:
> > There's tons of sparc specific drivers not handled here.
> > For example, drivers/scsi/sun_esp.c, drivers/scsi/qlogicpti.c,
> > and on and on and on.
> > 
> > In fact there are more sparc specific drivers using
> > of_platform_driver under drivers/ thans powerpc :)
> > 
> > I don't think I want to do this for now, sorry Al.
> 
> Argh...  Looks like that got picked despite the NAK ;-/

It looks like all of your patches got applied regardless of
what followups they received.

I'll chalk this up to a simple oversight given that Linus just
got back from a week of vacation :)

> Linus, could you revert commit e669dae6141ff97d3c7566207f5de3b487dcf837?
> NAKed by maintainer, so...

I'd really like the other sparc changes to get kicked out as well,
which as I just indicated in another reply I put into my
sparc-next-2.6 tree instead.  The risk is just not worth it as I've
broken sparc already with similar "obvious" section fixups.

This is really a big hassle for another reason, because Sam is in the
process of unifying sparc32 and sparc64 in the sparc-next-2.6 tree.

Now that these changes went into upstream it's possible that I'm going
to have a lot of fun sorting out the merge conflicts.  Although some
initial test merges indicate that we might be able get away with this
one with only minor pain.


