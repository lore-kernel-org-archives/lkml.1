Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab0CGBNn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 20:13:43 -0500
Received: from thunk.org ([69.25.196.29]:33978 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950Ab0CGBNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 20:13:42 -0500
Date: Sat, 6 Mar 2010 20:13:35 -0500
From: tytso@mit.edu
To: Dave Airlie <airlied@gmail.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] X doesn't work with 2.6.33 (can't find any input
 devices)
Message-ID: <20100307011335.GA5149@thunk.org>
Mail-Followup-To: tytso@mit.edu, Dave Airlie <airlied@gmail.com>,
	David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
References: <20100303151720.GA3191@thunk.org>
 <20100303.072007.170106625.davem@davemloft.net>
 <20100305044054.GB5747@thunk.org>
 <21d7e9971003042111n5b5145c5sd9b62b53522cfd86@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d7e9971003042111n5b5145c5sd9b62b53522cfd86@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 05, 2010 at 03:11:53PM +1000, Dave Airlie wrote:
> On Fri, Mar 5, 2010 at 2:40 PM,  <tytso@mit.edu> wrote:
> > See Linus's complaints over the nouveau driver; it's the same
> > principle; something is really broken.
> 
> Not really, this is just somebody doing something stupid one would hope,
> 
> does lshal on both kernels give similiar results?

No, it's quite different.    See attached.

--- lshal-2.6.33	     2010-03-06 10:15:44.837265508 -0500
+++ lshal-2.6.32-git4	     2010-03-06 18:45:35.782582002 -0500
@@ -1,17 +1,2446 @@
 
-Dumping 23 device(s) from the Global Device List:
+Dumping 149 device(s) from the Global Device List:
 -------------------------------------------------
...


It looks like it's fixed as of 2.6.33-git10.  Hopefully whoever fixed
it will backport it to 2.6.33-STABLE, since this will seriously screw
up anyone wanting to use 2.6.33 at least on Ubuntu; I don't know about
other distributions.

					- Ted
