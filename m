Return-Path: <linux-kernel-owner+w=401wt.eu-S932915AbXBVKBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932915AbXBVKBV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 05:01:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932950AbXBVKBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 05:01:21 -0500
Received: from tim.rpsys.net ([194.106.48.114]:42303 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932915AbXBVKBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 05:01:20 -0500
Subject: Re: no backlight on radeon after recent kernel "upgrade"s
From: Richard Purdie <rpurdie@rpsys.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Alex Romosan <romosan@sycorax.lbl.gov>,
       Yaroslav Halchenko <kernel@onerussian.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net,
       James Simmons <jsimmons@infradead.org>
In-Reply-To: <20070222011017.GA8845@khazad-dum.debian.net>
References: <20070219044616.GC25659@washoe.onerussian.com>
	 <20070219000412.acad13de.akpm@linux-foundation.org>
	 <1171876788.6046.3.camel@localhost.localdomain>
	 <877iub9mu2.fsf@sycorax.lbl.gov>
	 <1172097718.5790.29.camel@localhost.localdomain>
	 <20070221231706.GA3336@khazad-dum.debian.net>
	 <1172103159.5790.45.camel@localhost.localdomain>
	 <20070222005122.GA7928@khazad-dum.debian.net>
	 <20070222011017.GA8845@khazad-dum.debian.net>
Content-Type: text/plain
Date: Thu, 22 Feb 2007 10:00:50 +0000
Message-Id: <1172138450.5837.34.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-21 at 23:10 -0200, Henrique de Moraes Holschuh wrote:
> On Wed, 21 Feb 2007, Henrique de Moraes Holschuh wrote:
> > > * 'cat brightness' != 'cat actual_brightness' upon bootup (doesn't have
> > 
> > Hmm, I see this in 2.6.20 too.  And brightness is the one that is buggy.  I
> > will look into it.
> 
> Now, that was trivial to fix, and I will reply with a patch (which will have
> Cc's trimmed to just the MLs and Richard).
> 
> But really, should not the backlight *class* be doing the initial update of
> the brightness?  Looks like something that every device would need to do if
> the class doesn't do it, and unlike the "power it off on unregister" thing,
> I can't think of a reason not to do it for every backlight class device.
> 
> Please ACK the ibm-acpi patch in my next message if you'd like me to submit
> it to Len Brown for merging into 2.6.21, or NACK it if you'd rather do it in
> the backlight class core.

We can't change the backlight class code since some hardware can't read
from the device, only write to it. Initialisation in that case is a bit
different.

Richard



