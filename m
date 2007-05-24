Return-Path: <linux-kernel-owner+w=401wt.eu-S1753451AbXEXUo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbXEXUo6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 16:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbXEXUol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 16:44:41 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47613 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbXEXUok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 16:44:40 -0400
Message-ID: <4655F932.20006@garzik.org>
Date: Thu, 24 May 2007 16:44:34 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: David Hollis <dhollis@davehollis.com>
CC: Greg KH <greg@kroah.com>, Dave Jones <davej@redhat.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [stable] Wanted: Allow adding new device IDs during the	-stable
 cycle
References: <46533314.10206@redhat.com> <20070522184733.GA9357@kroah.com>	<46533EA8.7020602@garzik.org> <20070522193538.GA885@kroah.com>	<20070522195135.GG12157@redhat.com>  <20070522221718.GC2302@kroah.com> <1179969655.4489.3.camel@dhollis-lnx.sunera.com>
In-Reply-To: <1179969655.4489.3.camel@dhollis-lnx.sunera.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Hollis wrote:
> With the asix.c driver, you can't just add the USB IDs and have it work.
> Each ID also needs to be told which driver structure to use, since the
> driver itself supports three similar, but distinct chips.  Adding the
> IDs to the driver itself is naturally trivial, but adding via sysfs or
> the like doesn't work.  I would imagine that there are other drivers
> that operate quite similarly.

As is evident from the patches that do upstream (a requirement for 
-stable), it depends on the driver.  Some drivers work just fine with a 
simple ID addition.

Review the thread, we are just talking about the patches where adding an 
ID is the only work necessary.

	Jeff


