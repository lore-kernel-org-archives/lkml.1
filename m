Return-Path: <linux-kernel-owner+w=401wt.eu-S1755668AbZLDKYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668AbZLDKYB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 05:24:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755308AbZLDKYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 05:24:00 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:9570 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443AbZLDKX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 05:23:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:x-url:user-agent;
        b=MYGGcZWdTl/z6GGx1DO4k21NYJBao5El75l8JTAYwfLUF/iwYLa6fQrX6j/9yBb3/b
         qAqCJMNpnkZqCj6i5pXEM3JifRy4QKyMuc4onvmAFtSqBzvT++FajcQNPCpT1L1apb2k
         sZJe3u1jfIchg/KpMzeWJfBBsmFW4T+9Siv5s=
Date: Fri, 4 Dec 2009 12:24:01 +0200
From: Amit Kucheria <amit.kucheria@canonical.com>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: List Linux Kernel <linux-kernel@vger.kernel.org>,
       Dinh.Nguyen@freescale.com, s.hauer@pengutronix.de,
       grant.likely@secretlab.ca, r.herring@freescale.com,
       linux-arm-kernel@lists.infradead.org, daniel@caiaq.de,
       valentin.longchamp@epfl.ch
Subject: Re: [RFC][PATCH 02/10] arm: mxc: base support for Freescale i.MX51
 processor
Message-ID: <20091204102401.GB3747@matterhorn.verdurent.com>
References: <cover.1259893118.git.amit.kucheria@canonical.com>
 <6608c4dca645d87efce78ae0b7dbad265004f482.1259893118.git.amit.kucheria@canonical.com>
 <20091204094122.GC10910@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091204094122.GC10910@pengutronix.de>
X-URL: http://www.verdurent.com/
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09 Dec 04, Uwe Kleine-König wrote:
> Hello,
> 
> On Fri, Dec 04, 2009 at 04:47:02AM +0200, Amit Kucheria wrote:
> > Kconfig and Makefiles to enable the i.MX51 processor separated to help ease
> > the review process
> > 
> > Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
> > ---

<snip>

> > diff --git a/arch/arm/mach-mx5/Makefile b/arch/arm/mach-mx5/Makefile
> > new file mode 100644
> > index 0000000..e4cf91f
> > --- /dev/null
> > +++ b/arch/arm/mach-mx5/Makefile
> > @@ -0,0 +1,9 @@
> > +#
> > +# Makefile for the linux kernel.
> > +#
> > +
> > +# Object file lists.
> > +obj-y   := cpu.o mm.o clock.o devices.o
> I couldn't find arch/arm/mach-mx5/cpu.c neither in your series nor in
> mainline.  Didn't check the others.  Is it just me?

Patch 05/10 is stuck in the L-A-K moderation queue for size restrictions.
Perhaps you could get it from LKML archives[1]?

[1] http://lkml.org/lkml/2009/12/3/500

Regards,
Amit
-- 
------------------------------------------------------------
Amit Kucheria, Finland
------------------------------------------------------------
