Return-Path: <linux-kernel-owner+w=401wt.eu-S1756602AbXH0MJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602AbXH0MJb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 08:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756381AbXH0MIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 08:08:20 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47665 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752536AbXH0MIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 08:08:18 -0400
Date: Mon, 27 Aug 2007 12:00:29 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [PATCH, RFC] wake up from a serial port
Message-ID: <20070827100029.GB1972@elf.ucw.cz>
References: <Pine.LNX.4.60.0708260010250.3809@poirot.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0708260010250.3809@poirot.grange>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Enable wakeup from serial ports, make it run-time configurable over sysfs, 
> e.g.,
> 
> echo enabled > /sys/devices/platform/serial8250.0/tty/ttyS0/power/wakeup
> 
> Requires
> 
> # CONFIG_SYSFS_DEPRECATED is not set
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Hmm, interesting, looks ok to me. What are you using it for?
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
