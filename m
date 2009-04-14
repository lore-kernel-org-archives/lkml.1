Return-Path: <linux-kernel-owner+w=401wt.eu-S1756184AbZDNO0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbZDNO0w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 10:26:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753581AbZDNO0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 10:26:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50645 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751599AbZDNO0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 10:26:40 -0400
Date: Tue, 14 Apr 2009 15:26:18 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: martin@valinux.com, gareth@valinux.com, airlied@linux.ie,
       dri-devel@lists.sourceforge.net, David Woodhouse <dwmw2@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>
Subject: Re: [PATCH] radeon_cp: use request_firmware
Message-ID: <20090414142618.GY3051@decadent.org.uk>
References: <1239640067.3237.4.camel@ht.satnam> <1239647163.18110.150.camel@deadeye.i.decadent.org.uk> <1239684881.3033.11.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239684881.3033.11.camel@ht.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 10:24:41AM +0530, Jaswinder Singh Rajput wrote:
> On Mon, 2009-04-13 at 19:26 +0100, Ben Hutchings wrote:
> > Please use <ben@decadent.org.uk> for all mail related to my work on
> > firmware separation, which has nothing to do with my employment.
> > 
> > On Mon, 2009-04-13 at 21:57 +0530, Jaswinder Singh Rajput wrote:
> > > Moved datah before datal because datah is required before datal.
> > > 
> > > Firmware blob looks like this...
> > > 	__be32 datah
> > > 	__be32 datal
> > > 
> > > Thanks to Ben for help and testing.
> > [...]
> > 
> > This is out of date as there are now an r600_microcode.h and r600_cp.c.
> > My latest patch (not posted anywhere yet) is at
> > <http://womble.decadent.org.uk/tmp/fw-patch/0003-radeon-Use-request_firmware.patch> (patches 0001-0003 should be applicable in order to drm-2.6/drm-linus).  But I don't have any R600/R700 hardware to test it on.
> > 
> 
> I am very surprise you take my patches and post them without CC to me ?

As I said, I haven't posted those yet.

> Please use my signed-off in my patches in first place:
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> 
> Or prepare incremental patch to my patch.
> 
> Here are other stolen patches without CC and my Signed-off:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=06e1f9ffa023c030bc87491e75f625f5da4e7d97

So far as I can remember (I haven't checked) your patch was defective and
I considered that to be a complete rewrite.

> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b775a750c3afacbfac884537d466d34d50b1023b

That was credited and cc'd to <jaswinder@infradead.org> which maybe isn't the
best address to use.  Well, now that I look again, it appears that I forgot to
cc you on the final version which was accepted.  I'm sorry about that.

> Why you do this ?
 
I don't copy Signed-off-by if I make significant changes as the original
author should not be held responsible for any errors.  I'll be happy to
ask for your S-o-b before submitting a patch based on your work in future.

Ben.

-- 
Ben Hutchings
Experience is directly proportional to the value of equipment destroyed.
                                                         - Carolyn Scheppner
