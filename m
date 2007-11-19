Return-Path: <linux-kernel-owner+w=401wt.eu-S1755578AbXKSWcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbXKSWcv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 17:32:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbXKSWco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 17:32:44 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45241
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750704AbXKSWcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 17:32:43 -0500
Date: Mon, 19 Nov 2007 14:32:41 -0800 (PST)
Message-Id: <20071119.143241.165308264.davem@davemloft.net>
To: david-b@pacbell.net
Cc: stern@rowland.harvard.edu, zwane@arm.linux.org.uk, tytso@mit.edu,
       torvalds@linux-foundation.org, stable@kernel.org,
       reviews@ml.cw.f00f.org, rdunlap@xenotime.net, mkrufky@linuxtv.org,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       jmforbes@linuxtx.org, gregkh@suse.de, dely.l.sy@intel.com,
       davej@redhat.com, chuckw@quantumlinux.com, cebbert@redhat.com,
       cavokz@gmail.com, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org
Subject: Re: [patch 19/26] USB: mutual exclusion for EHCI init and port
 resets
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071119195955.B0C482214F3@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
References: <Pine.LNX.4.44L0.0711191403400.3005-100000@iolanthe.rowland.org>
	<20071119195955.B0C482214F3@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <david-b@pacbell.net>
Date: Mon, 19 Nov 2007 11:59:55 -0800

> > This addition certainly won't hurt.  Did we ever get any feedback as to 
> > whether it actually helped?
> 
> ISTR that davem refused to try it, after reporting an
> intermittent failure on the original patch (which only
> addresses one end of that hardware race).
> 
> So, no ... but given we know that closing only one side
> of the race isn't quite enough, I think we need it anyway.

I think we should put all these changes in because at a minimum
it's a step in the right direction even if it doesn't close
the hole %100.

So please let's merge the mutex and the msleep() change in
ASAP, thanks.
