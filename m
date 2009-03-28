Return-Path: <linux-kernel-owner+w=401wt.eu-S1757555AbZC1KsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555AbZC1KsH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 06:48:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753611AbZC1Krh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 06:47:37 -0400
Received: from ftp.linux-mips.org ([213.58.128.207]:41541 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbZC1Krg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 06:47:36 -0400
Date: Sat, 28 Mar 2009 11:46:27 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Dmitri Vorobiev <dmitri.vorobiev@movial.fi>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
       peter fuerst <post@pfrst.de>,
       Henrik Kretzschmar <henne@nachtwindheim.de>
Subject: Re: [PATCH 46/58] move sgiwd93's probe function to .devinit.text
Message-ID: <20090328104627.GE17386@linux-mips.org>
References: <20090327232153.GA16348@pengutronix.de> <1238196439-16535-46-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1238196439-16535-46-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 28, 2009 at 12:27:07AM +0100, Uwe Kleine-König wrote:

> A pointer to sgiwd93_probe is passed to the core via
> platform_driver_register and so the function must not disappear when the
> .init sections are discarded.  Otherwise (if also having HOTPLUG=y)
> unbinding and binding a device to the driver via sysfs will result in an
> oops as does a device being registered late.
> 
> An alternative to this patch is using platform_driver_probe instead of
> platform_driver_register plus removing the pointer to the probe function
> from the struct platform_driver.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: peter fuerst <post@pfrst.de>
> Cc: Henrik Kretzschmar <henne@nachtwindheim.de>

Acked-by: Ralf Baechle <ralf@linux-mips.org>

  Ralf
