Return-Path: <linux-kernel-owner+w=401wt.eu-S1758428AbYJWSaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758428AbYJWSaY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 14:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754503AbYJWSaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 14:30:10 -0400
Received: from mail.gmx.net ([213.165.64.20]:56028 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753436AbYJWSaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 14:30:09 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX197koET5ZR74sXp8x8k/RJpOiRHD61V2+3Fh6MUof
	B+dQx9SJLAzeGA
Date: Thu, 23 Oct 2008 20:30:23 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Michael Weiser <michael@weiser.dinsnail.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: rtc/i2c-mpc stops working with 2.6.27 on Linkstation HG (powerpc)
In-Reply-To: <20081022191650.GA11406@weiser.dinsnail.net>
Message-ID: <Pine.LNX.4.64.0810232029380.9657@axis700.grange>
References: <20081022191650.GA11406@weiser.dinsnail.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008, Michael Weiser wrote:

> Hello,
> 
> with 2.6.27(-gentoo) the rtc (Ricoh 5c372) is no longer found on my
> Linkstation HG. It seems, the i2c-mpc driver doesn't even find the I2C
> controller.
> 
> Could this be related to commit
> #0d1cde235874b00905bce23f659690d060ebf475 (powerpc/i2c: Convert i2c-mpc
> into an of_platform driver,
> http://kerneltrap.org/mailarchive/git-commits-head/2008/7/16/2522594/thread)?
> 
> What do I need to do, to make it work again?
> 
> The configs are virtually identical. The kernels are loaded with their
> respective dtb files. The dtb and dts files are identical anyways.

This is a known regression, see, e.g., here:

http://ozlabs.org/pipermail/linuxppc-dev/2008-October/064318.html

waiting for someone to find time to fix it.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
