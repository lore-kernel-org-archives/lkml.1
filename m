Return-Path: <linux-kernel-owner+w=401wt.eu-S1752546AbXCEABF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbXCEABF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 19:01:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbXCEABF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 19:01:05 -0500
Received: from tim.rpsys.net ([194.106.48.114]:57192 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbXCEABE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 19:01:04 -0500
Subject: Re: [PATCH] USB/gadget: PXA27x USB device support
From: Richard Purdie <rpurdie@rpsys.net>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-usb-devel@lists.sourceforge.net,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <20070302174758.GA22441@enneenne.com>
References: <20061121141041.GB15001@enneenne.com>
	 <20070302174758.GA22441@enneenne.com>
Content-Type: text/plain
Date: Mon, 05 Mar 2007 00:00:17 +0000
Message-Id: <1173052817.5832.33.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-02 at 18:47 +0100, Rodolfo Giometti wrote:
> Hello,
> 
> here my new proposal for PXA27x USB device support. In this version I
> fixed the power management support (suspend/resume).
> 
> As already mentioned in my previous, I know this driver is quite far
> from perfection but, in my opinion, it could be a good starting point
> to add this support into the kernel.
> 
> I use the driver from my platform specific file into
> "arch/arm/mach-pxa/" by using the following code:

There is some code which might be useful in:

http://www.rpsys.net/openzaurus/patches/usb_add_epalloc-r3.patch
http://www.rpsys.net/openzaurus/patches/usb_pxa27x_udc-r3.patch

In the past I've tried to merge other peoples changes into these to make
one more useful driver but there are known issues with try to merge
either of these into mainline (particularly RNDIS support).

Cheers,

Richard

