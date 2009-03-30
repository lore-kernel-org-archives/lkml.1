Return-Path: <linux-kernel-owner+w=401wt.eu-S1754103AbZC3Nhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbZC3Nhh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 09:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750941AbZC3NhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 09:37:25 -0400
Received: from nn7.de ([85.214.94.156]:33845 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937AbZC3NhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 09:37:25 -0400
Subject: Re: enabling kms for i915 disables brightness control and xrandr
From: Soeren Sonnenburg <sonne@debian.org>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-kernel@vger.kernel.org, Eric Anholt <eric@anholt.net>,
       dri-devel@lists.sourceforge.net,
       Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <1238332957.4185.74.camel@localhost>
References: <1238322841.4185.36.camel@localhost>
	 <20090329130702.GA23660@sucs.org>  <1238332957.4185.74.camel@localhost>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 30 Mar 2009 15:37:19 +0200
Message-Id: <1238420239.4575.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-03-29 at 15:22 +0200, Soeren Sonnenburg wrote:
> On Sun, 2009-03-29 at 14:07 +0100, Sitsofe Wheeler wrote:
> > (CC'ing dri-devel, Eric Anholt and Jesse Barnes)
> > 
> > On Sun, Mar 29, 2009 at 12:34:01PM +0200, Soeren Sonnenburg wrote:
> > > Dear all,
> > > 
> > > I am not sure if this is just a user error/ too old userspace problem,
> > 
> > [User stated that 2.6.3 intel driver is being used in another email]
> 
> Just to not cause any (further?) confusion, I was using 2.6.1 when I
> wrote that email and after compiling/upgrading to 2.6.3 a number of
> problems vanished (like Xv works, screen resolution is correct, things
> are *a lot* faster with UXA). However, brightness still only works via
> setpci and xrandr only shows the 1024x600 modeline.
> 
> > > but I recognized that when I enable kernel based modesetting on a intel
> > > 945 based samsung nc 10 netbook, I loose brightness control from within
> > > X and X resolutions are wrong (instead of 1024x600 it is 1024x1024) and
> > > xrandr does no longer have the all the modelines ranging from 1024x600
> > > to 640x350... Trying to change resolutions / setting the brightness via
> > > xrandr results in error messages being printed. 
> > > 
> > > Furthermore, this same flag disables Xv support..
> > > 
> > > However, screen switches between terminal and X are quite fast now
> > > (without any flicker) and suspend and everything works stably.
> > > 
> > > I recognized that I can set the brightness via
> > > 
> > > setpci -s 00:02.1 F4.B=XX
> > > 
> > > (XX ranging from 00 to FF) just fine...

One more thing: Connecting an external display I could turn it on via
xrandr --auto successfully. However, it was not possible to turn the
internal display off (xrandr --output LVDS1 --off) and switching to the
console with the external display connected I managed to freeze the
machine. Turning the external display off worked somehow (the display
then showed vertical stripes) but I could switch to console.

Soeren.
-- 
For the one fact about the future of which we can be certain is that it
will be utterly fantastic. -- Arthur C. Clarke, 1962
