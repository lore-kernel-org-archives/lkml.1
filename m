Return-Path: <linux-kernel-owner+w=401wt.eu-S1756850AbYKVX6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850AbYKVX6R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 18:58:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753739AbYKVX6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 18:58:07 -0500
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:46983 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753724AbYKVX6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 18:58:06 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=G9iy6rxTyHh1bCWPtF1tC5vpn3QYlLwgh1+2UGn6LIXARPtgGtAZfc9fo4eNhMq9wligqgAkSSYsahbcYNjRPJhMVwvGl0jypAx4ZkPGKOZR8mUDgKP8AAkJke1aohzUcRzMYtfx/q4rCq7gKHWhhv4njAK+QJbgxHSkSInU5KM=  ;
X-YMail-OSG: zMdvPN4VM1kPU4l3fOTY9_NB0TP_lv1D0896Lioft_eQ4OjgpDsytfwrqcYrPiQUCyMnGHROyYU2ddxrSFBf5ZGTAlZ.MPW.jhXilI6oDdSPPI11a2v_vXivot3slvoPfsvPxF7im5OHGhP4eBxuvOy1gjIHSYkQearYTQ8-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Stefan Schmidt <stefan@openmoko.org>
Subject: Re: [spi-devel-general] [patch 05/14] mfd: PCAP2 driver
Date: Sat, 22 Nov 2008 15:58:03 -0800
User-Agent: KMail/1.9.10
Cc: spi-devel-general@lists.sourceforge.net, eric.y.miao@gmail.com,
       linux-kernel@vger.kernel.org, sameo@openedhand.com,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Daniel Ribeiro <drwyrm@gmail.com>
References: <20081121160403.073751031@dodger.lab.datenfreihafen.org> <200811221119.27981.david-b@pacbell.net> <20081122233356.GC24437@datenfreihafen.org>
In-Reply-To: <20081122233356.GC24437@datenfreihafen.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200811221558.03915.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 November 2008, Stefan Schmidt wrote:
> > > +config EZX_PCAP
> > > +       bool "PCAP Support"
> > > +       depends on PXA_EZX
> > 
> > It only builds on one platform.  Now, that may make sense if it's
> > an ASIC currently used only on that platform; it's a "hardware"
> > dependency.  But it's not a necessary "software" dependency, no
> > code here seems to rely on PXA hardware, or EZX hardware.
> 
> It is software and we are on the way fixing it.

Good.  I've only seen patch #5 of this series, so I couldn't
tell what else was up.


> > One of the goals of getting drivers into mainline is to get rid
> > of needless dependencies ... and thereby open the code up to
> > many more developers.  Some may do nothing more than cleanup;
> > others will be doing API overhauls, which can be a PITA if you
> > place needless build dependencies on your code.
> 
> Understand. We have been a bit lazy here, sorry. That is mostly based on the
> fact that we have never seen any other linux devices having this chip. Only some
> low power feature phones with the P2K OS from Motorola. Anyway, we work on it to
> get it more generic now.

Looks to me like you're almost all the way there already!  :)

Much like we're doing with the twl4030 family chips ... they're
used on a lot of OMAP3 (and some OMAP2430) boards, and some
build dependencies evolved over the past year or so while
the driver support was maturing out of mainline.  Patches to
remove them are ready now, and should be "cooked" enough to
make the 2.6.29 merge window.

- Dave
