Return-Path: <linux-kernel-owner+w=401wt.eu-S1764284AbYCSVIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764284AbYCSVIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761381AbYCST5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:57:51 -0400
Received: from mylar.outflux.net ([69.93.193.226]:37211 "EHLO
	mylar.outflux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761369AbYCST5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:57:49 -0400
X-Greylist: delayed 898 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Mar 2008 15:57:48 EDT
Date: Tue, 18 Mar 2008 14:14:50 -0700
From: Bryce Harrington <bryce@canonical.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Justin Madru <jdm64@gawab.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [Regression: 2.6.25-rc5: Blank Screen: Intel 945]
Message-ID: <20080318211450.GU7206@bryceharrington.org>
References: <47D828BB.2000702@gawab.com> <47DDC92A.7000703@gawab.com> <20080318190752.GS7206@bryceharrington.org> <200803181300.39857.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803181300.39857.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-HELO: localhost
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2008 at 01:00:39PM -0700, Jesse Barnes wrote:
> > I could get it to build by ifdefing out th pci_device_map_range call,
> > and then adding -lpciaccess to the linker, however it segfaults without
> > that call.
> >
> > Does LIBPCIACCESS require xserver 1.4?  (We have 1.3 in Hardy).
(Obviously I meant 1.5 / 1.4 above.  Dah.)

> No, libpciaccess should be standalone, but the Intel driver requires 0.10 or 
> better... Which version are you building against?

I've put in a sync request for this to get updated for hardy.  (It still
will only be in universe, so won't be built automatically with -intel,
but at least users will be able to more easily compile it by hand.)

Meanwhile, here is a Ubuntu Hardy build of Debian's package:

  http://people.ubuntu.com/~bryce/Testing/libpciaccess/libpciaccess-dev_0.10-1_i386.deb
  http://people.ubuntu.com/~bryce/Testing/libpciaccess/libpciaccess0_0.10-1_i386.deb

Bryce

