Return-Path: <linux-kernel-owner+w=401wt.eu-S1759653AbZDSIcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759653AbZDSIcc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 04:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbZDSIcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 04:32:23 -0400
Received: from mail.gmx.net ([213.165.64.20]:44416 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751966AbZDSIcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 04:32:22 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18CNVJjg1UCjQQKMFw4IhMg+kZd1uA6Gj5aekAVLx
	mc7zNvHBKAz9os
Date: Sun, 19 Apr 2009 10:32:24 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: David Miller <davem@davemloft.net>
cc: florian@openwrt.org, peter@holik.at, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb driver for intellon based PLC like devolo dlan duo
In-Reply-To: <20090418.211503.13481677.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0904191025060.4369@axis700.grange>
References: <Pine.LNX.4.64.0904172102300.5119@axis700.grange>
 <20090418.015541.05303908.davem@davemloft.net> <Pine.LNX.4.64.0904182146220.14879@axis700.grange>
 <20090418.211503.13481677.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Apr 2009, David Miller wrote:

> From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Date: Sat, 18 Apr 2009 21:54:11 +0200 (CEST)
> 
> > If you are working with that file and see a call to reg_write() you
> > know where to look for it.
> 
> I would never use such a generic name for a driver local routine.
> 
> For example, in the tg3 driver we use "tr32()" and "tw32()" so that
> at least some inkling of the driver name, even if it is just one
> character, prefixes the name.
> 
> This extends to other driver's I've written.  The niu driver thus
> uses "tr64()" and "nw64()".

Ok, we currently have drivers for mt9m001, mt9m111, mt9t031, and mt9v022. 
Which letter would you take for them?:-) You'd have to take at least two 
characters like "m0", "m1", "t0", and "v0" but that wouldn't be very 
intuitive IMHO either. Take four characters like m001r16() and it looks 
pretty bad compared to all routines being called mt9m001_*.

> This is just common sense as far as I'm concerned.  It is just
> as straight forward as not using variable names like 'foo'.

I'd say that's subjective (not the latter, but the former):-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
