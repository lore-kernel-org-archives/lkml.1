Return-Path: <linux-kernel-owner+w=401wt.eu-S938543AbYCSVqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938543AbYCSVqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759653AbYCSURw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:17:52 -0400
Received: from mylar.outflux.net ([69.93.193.226]:53159 "EHLO
	mylar.outflux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759388AbYCSURv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:17:51 -0400
Date: Tue, 18 Mar 2008 13:53:18 -0700
From: Bryce Harrington <bryce@canonical.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Justin Madru <jdm64@gawab.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [Regression: 2.6.25-rc5: Blank Screen: Intel 945]
Message-ID: <20080318205318.GT7206@bryceharrington.org>
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
> 
> No, libpciaccess should be standalone, but the Intel driver requires 0.10 or 
> better... Which version are you building against?

Looks like we still are on 0.8.  I can check into upping us to 0.10 this
afternoon or tomorrow - even though it's still in universe and we can't
include it yet by default for -intel, that'll make it simpler for users
that need to build it.  Stay tuned.

Bryce

