Return-Path: <linux-kernel-owner+w=401wt.eu-S1754942AbZBZKuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942AbZBZKuO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 05:50:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754401AbZBZKt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 05:49:59 -0500
Received: from th-mail-b0119.gradwell.net ([193.111.201.43]:41462 "EHLO
	th-mail-b0119.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754387AbZBZKt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 05:49:58 -0500
X-Greylist: delayed 1156 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Feb 2009 05:49:58 EST
Date: Thu, 26 Feb 2009 10:30:32 +0000
From: Alex Buell <alex.buell@munted.org.uk>
To: Greg KH <greg@kroah.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Unused modules in 2.6.x
Message-ID: <20090226103032.185a8bbd@lithium.local.net>
In-Reply-To: <20090225192810.GA6150@kroah.com>
References: <20090225175249.30e47b85@lithium.local.net>
	<20090225192810.GA6150@kroah.com>
Organization: One tortoiseshell cat, very high maintenance
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.11; i686-pc-linux-gnu)
X-Face: "wUuhsy:X)M;>-dA\j"&y@*\$91]iX10Iv1WG_oNbGYpo,eqc06O?"VSeRTx]xM\LiITUh01z}<|GF/4Gzz(MAU~;p4AS,%TB69M:vB-9+i'#W7$UQCW&UP#zt{VdLlzEiw8k~jL<
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Feb 2009 11:28:10 -0800, I waved a wand and this message
magically appears in front of Greg KH:

> On Wed, Feb 25, 2009 at 05:52:49PM +0000, Alex Buell wrote:
> > Hi,
> > 
> > Perhaps I missed something when the 2.6.x kernels got started a few
> > years back, but why is it not possible for unused modules to be
> > automatically unloaded anymore i.e with rmmod -a? I remember being
> > able to do that with the 2.2.x and 2.4.x series a long time ago.
> 
> Because if you do that, lots of modules that were being "used" by the
> system would get unloaded (usb host controllers, network drivers,
> etc.)
> 
> So it makes sense not to do that anymore.  See the linux-kernel
> archives about 6 years ago for details if you are curious about this
> historical issue (hint, it could burn you very badly even in 2.2 and
> 2.4...)

I see, thanks. 
-- 
http://www.munted.org.uk

Fearsome grindings.
