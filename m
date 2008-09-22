Return-Path: <linux-kernel-owner+w=401wt.eu-S1755154AbYIVXr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154AbYIVXr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 19:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754140AbYIVXrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 19:47:48 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53493 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbYIVXrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 19:47:47 -0400
Date: Mon, 22 Sep 2008 19:47:08 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: David Miller <davem@davemloft.net>, andrea_monta@inwind.it,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, stable@kernel.org
Subject: Re: OOPS bug KERNEL LINUX- Version 2.6.26
Message-ID: <20080922234649.GA26219@tuxdriver.com>
References: <K7M9ZI$69A44BBF23D86D612A80B0EA98EEEE6B@libero.it> <200809230025.03680.IvDoorn@gmail.com> <20080922222716.GI3660@tuxdriver.com> <200809230032.37255.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809230032.37255.IvDoorn@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2008 at 12:32:36AM +0200, Ivo van Doorn wrote:
> On Tuesday 23 September 2008, John W. Linville wrote:
> > On Tue, Sep 23, 2008 at 12:25:03AM +0200, Ivo van Doorn wrote:
> > > Hi,
> > > 
> > > > > 1. Problem with usb-wireless-key 
> > > > > 2. I can't find my device typing ifconfig -a or iwconfig I don't find any wireless attached device. But I have my usb wireless connected. A belkin usb wireless key.Before, with the kernel 2.6.25 all worked well
> > > > > 3. nothing
> > > > > 4. Linux version 2.6.26 (root@clementino) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #1 PREEMPT Mon Sep 22 15:57:45 CEST 2008
> > > > > 5.
> > > 
> > > You missed the message from rt2x00 2 lines above this trace, which undoubtly have said something like:
> > > 	"Invalid RT chipset detected."
> > > which is triggered when rt73usb is loaded for a device it does not support
> > > 
> > > The current workaround for this issue is blacklisting rt73usb and making sure the driver
> > > which is required for your driver is loaded instead.
> > > 
> > > I'll look into the reason why this actually triggers a NULL pointer, since that is obviously a nasty bug.
> > 
> > -stable needs a patch similar to the one here:
> > 
> > 	http://people.redhat.com/linville/kernels/rhel5/patches/jwltest-rt2x00lib-probe-fail.patch
> 
> Ah yes, that would be a good one.
> I kind of assumed it was already merged, and hadn't actually verified that yet. ;)

Well the code in 2.6.27 is different, this patch is no longer necessary
(and doesn't apply).

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
