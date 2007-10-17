Return-Path: <linux-kernel-owner+w=401wt.eu-S935879AbXJQDRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935879AbXJQDRz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 23:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758291AbXJQDRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 23:17:46 -0400
Received: from fencepost.gnu.org ([140.186.70.10]:49822 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758017AbXJQDRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 23:17:45 -0400
Subject: Re: Distinguishing releases from pre-rc snapshots
From: Pavel Roskin <proski@gnu.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20071016224126.3679aea6@bree.surriel.com>
References: <1192587763.3672.24.camel@dv>
	 <20071016224126.3679aea6@bree.surriel.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 16 Oct 2007 23:17:43 -0400
Message-Id: <1192591063.3672.46.camel@dv>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-2.fc8) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-10-16 at 22:41 -0400, Rik van Riel wrote:
> On Tue, 16 Oct 2007 22:22:43 -0400
> Pavel Roskin <proski@gnu.org> wrote:
> 
> > I'm trying to keep some external drivers up to date with the kernel,
> > and the first two weeks after the release is the worst time for me.
> 
> Consider this an incentive to submit your code for inclusion
> in the upstream kernel.  Having all the common drivers integrated
> in the mainline kernel makes it much easier for users to use all
> their hardware, external drivers are not just a pain for the developers.

The incentive has already worked for MadWifi, which has landed in the
wireless-2.6 repository under the name "ath5k".  Still, there is a lot
of work to do, and some features won't appear in the kernel driver soon,
partly because they rely on the chipset features that still need to be
reverse engineered.

In the meantime, somebody has to maintain the old madwifi and release
fixed for security and kernel compatibility.

Also, there are drivers that are just to unwieldy to be shaped into
something resembling a typical Linux driver.  linux-wlan-ng is such
project.  No matter what the incentive, it won't go to the kernel.
Maybe somebody will write a clean driver for Prism USB devices one day,
but it didn't happen so far.

Finally, there is a little at76_usb driver, which supports quite old
802.11b devices.  It's in wireless-2.6 as well, but I simply cannot
expect users to test it from there.  And if I make a standalone release,
I'd rather not make another one when 2.6.24 comes out.

-- 
Regards,
Pavel Roskin

