Return-Path: <linux-kernel-owner+w=401wt.eu-S932375AbXIMXpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375AbXIMXpF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 19:45:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755939AbXIMXos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 19:44:48 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57139 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270AbXIMXor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 19:44:47 -0400
Date: Thu, 13 Sep 2007 16:21:19 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Russell King <rmk@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] wake up from a serial port
Message-ID: <20070913232119.GA32307@kroah.com>
References: <200709100831.l8A8VUH6015446@imap1.linux-foundation.org> <20070910132703.2dd92485@the-village.bc.nu> <Pine.LNX.4.60.0709102251250.5200@poirot.grange> <20070911081220.GA20847@flint.arm.linux.org.uk> <Pine.LNX.4.60.0709111217470.19259@poirot.grange> <20070911121057.34b9e066@the-village.bc.nu> <Pine.LNX.4.60.0709122019100.5909@poirot.grange> <20070912153610.11c4f5cb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070912153610.11c4f5cb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2007 at 03:36:10PM -0700, Andrew Morton wrote:
> On Wed, 12 Sep 2007 20:50:10 +0200 (CEST)
> Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> 
> > Enable wakeup from serial ports, make it run-time configurable over sysfs, 
> > e.g.,
> > 
> > echo enabled > /sys/devices/platform/serial8250.0/tty/ttyS0/power/wakeup
> > 
> > Requires
> > 
> > # CONFIG_SYSFS_DEPRECATED is not set
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > 
> > ---
> > 
> > Following suggestions from Alan and Russell moved the may_wake_up checks 
> > to serial_core.c. This time actually tested - it does even work. Could 
> > someone, please, verify, that put_device after device_find_child is 
> > correct?
> 
> Seems right to me, from reading device_find_child() and its associated
> documentation.

Yes, that is correct.

thanks,

greg k-h
