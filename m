Return-Path: <linux-kernel-owner+w=401wt.eu-S1757452AbZHGOBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452AbZHGOBM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 10:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756752AbZHGOBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 10:01:11 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59675 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756665AbZHGOBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 10:01:10 -0400
Date: Fri, 7 Aug 2009 09:48:04 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Chris Clayton <chris2553@googlemail.com>
Cc: Frans Pop <elendil@planet.nl>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: ath5k - strange regulatory domain change
Message-ID: <20090807134803.GA7545@tuxdriver.com>
References: <c6b1100b0908070350t3101030bs4b3d2e7485ad9aee@mail.gmail.com> <200908071324.45269.elendil@planet.nl> <c6b1100b0908070556sb3f4f80sc757d8b100cbcb3c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c6b1100b0908070556sb3f4f80sc757d8b100cbcb3c@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 01:56:43PM +0100, Chris Clayton wrote:
> Thanks Frans,
> 
> 2009/8/7 Frans Pop <elendil@planet.nl>:
> > Chris Clayton wrote:
> >> Because of some problems with my Belkin Wireless G card  (model
> >> F5D7010) and the rt61pci driver, I've started to use a "no-name" card
> >> that is supported by the ath5k driver.
> >>
> >> A problem is that I have come across is that for some reason the CN
> >> regulatory domain is being set automatically. This doesn't happen with
> >> the Belkin (rt61) card. I have the following line in
> >> /etc/modprobe.d/modprobe.conf to set the regulatory domain to GB:
> >>
> >> options cfg80211 ieee80211_regdom=GB
> >
> > This issue has already been discussed extensively (after I reported it).
> > Please see the following thread: http://lkml.org/lkml/2009/7/8/421. It
> > contains a lot of information from the wireless maintainers.
> >
> 
> To sum this up then (as I understand things):
> 
> 1. I am the system administrator (root);
> 2. I am using a valid (albeit deprecated from 2.6.31) method to tell
> the wireless infrastructure that I want the regulatory domain set to
> GB;
> 3. GB is a valid code; and
> 4. the wireless infrastructure sets the regulatory domain to CN.
> 5. in 2.6.30, the wireless infrastructure does what I (the root user)
> tell it to do.
> 
> That's a regression in my book. Oh well! I do have the iw and crda
> applications installed, so I've taken that route of setting the
> regulatory domain to GB.

Are you actually getting the wrong regulatory rules enforced?  Or are
you merely bothered that it is reporting "CN" instead of "GB"?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
