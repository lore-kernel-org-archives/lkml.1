Return-Path: <linux-kernel-owner+w=401wt.eu-S1755943AbZFBPor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbZFBPor (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 11:44:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753783AbZFBPol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 11:44:41 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:42686 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800AbZFBPok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 11:44:40 -0400
Date: Tue, 2 Jun 2009 17:44:42 +0200
From: Andreas Mohr <andi@lisas.de>
To: Karsten Keil <isdn@linux-pingi.de>
Cc: Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mISDN GIT: hfcpci cleanup failure on IRQ weirdness
Message-ID: <20090602154442.GA10941@rhlx01.hs-esslingen.de>
References: <20090602140250.GA3607@rhlx01.hs-esslingen.de> <200906021653.36152.isdn@linux-pingi.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906021653.36152.isdn@linux-pingi.de>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jun 02, 2009 at 04:53:35PM +0200, Karsten Keil wrote:
> Yes from mISDN side, but I do not see what inside hisax prevent mISDN from
> getting IRQs after hisax was unloaded. And it works here on my test setup, I 
> can load mISDN without an error, after unloading hisax.

Mayyybe it's due to using kernel hisax with non-kernel (GIT) mISDN?

> > misdn_log still acts weird, though...
> >
> What does be weird here ?

See first mail.

> > BTW, could isdnlog be adapted to support mISDN relatively easily?
> > (since adding CAPI support would take longer I guess)
> 
> isdnlog (beside that the isdnlog code is ugly enough) should be not a big 
> issue, mISDN supports logging in parallel to the normal work, look at the
> tools/loghex.c  code how to create a logging socket.
> It should make things easier as with HiSax, since it will get the data as 
> binary and not as hexdump.

Of course one could get "something" out of a socket-based log sink,
but that "something" would likely be much less than the caller-resolving,
application-spawning stuff that isdnlog does - at least initially.


BTW, I'm migrating towards ISDN via KabelBW modem.

Andreas Mohr
