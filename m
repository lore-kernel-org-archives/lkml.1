Return-Path: <linux-kernel-owner+w=401wt.eu-S1757482AbYKVKb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbYKVKb3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 05:31:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756147AbYKVKbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 05:31:17 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:17329 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041AbYKVKbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 05:31:15 -0500
Date: Sat, 22 Nov 2008 11:30:59 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, Jean Delvare <khali@linux-fr.org>,
       Henrik Rydberg <rydberg@euromail.se>, Greg KH <greg@kroah.com>,
       rkoktarianto@gmail.com, mhoffman@lightlink.com, nicolas@boichat.ch,
       stable-commits@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: [stable] patch hwmon-applesmc-add-support-for-macbook-air.patch
  added to 2.6.27-stable tree
Message-ID: <20081122113059.334d203c@hyperion.delvare>
In-Reply-To: <20081121163219.601e68be@redhat.com>
References: <20081111184816.80D2D49036@coco.kroah.org>
	<4919E869.2060302@euromail.se>
	<20081111203341.GA29042@suse.de>
	<4919EF97.1010900@euromail.se>
	<20081111210121.GA29731@suse.de>
	<49241411.6020807@euromail.se>
	<20081119155436.GB4983@kroah.com>
	<4924B845.9060705@euromail.se>
	<20081120090121.08ee7b0c@hyperion.delvare>
	<20081121190142.GC31017@suse.de>
	<20081121163219.601e68be@redhat.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2008 16:32:19 -0500, Chuck Ebbert wrote:
> On Fri, 21 Nov 2008 11:01:42 -0800
> Greg KH <gregkh@suse.de> wrote:
> 
> > On Thu, Nov 20, 2008 at 09:01:21AM +0100, Jean Delvare wrote:
> > > On Thu, 20 Nov 2008 02:07:17 +0100, Henrik Rydberg wrote:
> > > > Absolutely. However, since the commits are all in Linus' tree, cherry-picking
> > > > sounds like the easiest thing, does it not? Here are the commits to applesmc,
> > > > in reverse chronological order, since the 2.6.27 release:
> > > > 
> > > > 468cc0320ed083e26364d9febde2679d981ed6a6 hwmon: applesmc: add support for Macbook 4
> > > > eefc488f96cdde6e152b45675b50bf380b95d99f hwmon: applesmc: add support for iMac 8
> > > > a66603257bf88bbe2c9fd6a97ee5dc24de15d196 hwmon: applesmc: add support for Macbook Pro 5
> > > > 181209a1d91756bfd83b1d6ce2008cea3ca225b6 hwmon: applesmc: add support for Macbook 5
> > > > 6e3530fa241ae759313496f67295c9252691ed04 hwmon: applesmc: add support for iMac 5
> > > > 8c9398d1e9766e3659e277acb2e8ca1c17684139 hwmon: applesmc: lighter wait mechanism, drastic improvement
> > > > 07e8dbd3ebbdedc71335049dd4b0d542cb038d7d hwmon: applesmc: Add support for Macbook Pro 3
> > > > d7549905f157f217b888edb0f2055f5090eaf1d8 hwmon: applesmc: Add support for Macbook Pro 4
> > > > 7b5e3cb28f52f42d8cf2b36771be580f33bbc7ae drivers/hwmon/applesmc.c: remove unneeded casts
> > > > f5274c972bac2d14c092a9c634e03f51785c7b76 hwmon: applesmc: add support for Macbook Air
> > > > 8bd1a12a51871f0c870612d8220b1485d6aefc73 hwmon: applesmc: allow for variable ALV0 and ALV1 package length
> > > > 02fcbd144d684167aa67b1d3ad68f18d265f2d08 hwmon: applesmc: prolong status wait
> > > > 84d2d7f2ee98dc9bd799790c89b5eb8280af2d37 hwmon: applesmc: fix the 'wait status failed: c != 8' problem
> > > > 05224091af06177c0ce7c1fae1f498455b47a6be hwmon: applesmc: specified number of bytes to read should match actual
> > > > 
> > > > The non-trivial ones are 8c9398, 8bd1a1 and 84d2d7.
> > > 
> > > This is too much for -stable IMHO.
> > 
> > In looking at the non-trivial ones, I agree, it's not just a "simple"
> > addition, sorry.
> 
> OTOH the driver is basically broken without all those patches.

Feel free to send a single patch disabling the driver altogether in
-stable if this is really the case.

-- 
Jean Delvare
