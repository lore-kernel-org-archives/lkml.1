Return-Path: <linux-kernel-owner+w=401wt.eu-S1753385AbZBZKbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbZBZKbI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 05:31:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753595AbZBZKaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 05:30:55 -0500
Received: from sov-mail-b0005.gradwell.net ([193.84.87.29]:51428 "EHLO
	sov-mail-b0005.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752914AbZBZKay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 05:30:54 -0500
Date: Thu, 26 Feb 2009 10:29:39 +0000
From: Alex Buell <alex.buell@munted.org.uk>
To: Michael Tokarev <mjt@tls.msk.ru>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Unused modules in 2.6.x
Message-ID: <20090226102939.42c92d34@lithium.local.net>
In-Reply-To: <49A59082.5040209@msgid.tls.msk.ru>
References: <20090225175249.30e47b85@lithium.local.net>
 <49A59082.5040209@msgid.tls.msk.ru>
Organization: One tortoiseshell cat, very high maintenance
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.11; i686-pc-linux-gnu)
X-Face: "wUuhsy:X)M;>-dA\j"&y@*\$91]iX10Iv1WG_oNbGYpo,eqc06O?"VSeRTx]xM\LiITUh01z}<|GF/4Gzz(MAU~;p4AS,%TB69M:vB-9+i'#W7$UQCW&UP#zt{VdLlzEiw8k~jL<
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Feb 2009 21:40:02 +0300, I waved a wand and this message
magically appears in front of Michael Tokarev:

> > Perhaps I missed something when the 2.6.x kernels got started a few
> > years back, but why is it not possible for unused modules to be
> > automatically unloaded anymore i.e with rmmod -a? I remember being
> > able to do that with the 2.2.x and 2.4.x series a long time ago.  
> 
> It's a pure userspace question now.  Well, almost, except of the
> single bit which were kept before 2.6  for each module - if it
> was loaded with -k flag (auto-unload) or not.

Thanks for that, I'll see if loading modules with -k still works in
2.6.x. 
 
> Better question to ask, IMHO, is why network drivers don't gets
> referenced properly as all other drivers are.  Because right now
> they're unused even if the network interfaces are up-n-running,
> and rmmod'ing a seemingly unused module will cause that particular
> interface to be removed too...

I'd have thought that hotplugging i.e. plug in an USB device in this
case would load the modules as and when required. 

If the interface is up, then it shouldn't have to be unloaded, I think.
I know I could just hack my initrds to remove any modules that I don't
want loaded at bootup but surely... :-D
-- 
http://www.munted.org.uk

Fearsome grindings.
