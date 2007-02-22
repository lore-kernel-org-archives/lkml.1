Return-Path: <linux-kernel-owner+w=401wt.eu-S933103AbXBVPzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933103AbXBVPzo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 10:55:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933106AbXBVPzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 10:55:44 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37745 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933103AbXBVPzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 10:55:43 -0500
Date: Thu, 22 Feb 2007 15:55:24 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Joel Becker <Joel.Becker@oracle.com>
cc: Yaroslav Halchenko <lists@onerussian.com>,
       Richard Purdie <rpurdie@rpsys.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] no backlight on radeon after recent kernel
 "upgrade"s
In-Reply-To: <20070222020951.GR7920@ca-server1.us.oracle.com>
Message-ID: <Pine.LNX.4.64.0702221549530.29542@pentafluge.infradead.org>
References: <20070219044616.GC25659@washoe.onerussian.com>
 <20070219000412.acad13de.akpm@linux-foundation.org>
 <1171876788.6046.3.camel@localhost.localdomain> <20070221055648.GM25659@washoe.onerussian.com>
 <Pine.LNX.4.64.0702220109450.17121@pentafluge.infradead.org>
 <20070222020951.GR7920@ca-server1.us.oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> On Thu, Feb 22, 2007 at 01:11:18AM +0000, James Simmons wrote:
> > > *$> grep BACKLIGH /boot/config-2.6.20 
> > > # CONFIG_FB_BACKLIGHT is not set
> > > CONFIG_BACKLIGHT_LCD_SUPPORT=y
> > > CONFIG_BACKLIGHT_CLASS_DEVICE=m
> > > CONFIG_BACKLIGHT_DEVICE=y
> > 
> > You need to explictly enable the backlight for your fbdev driver. It 
> > doesn't do the selecting magically for you.
> > Jus do a make "favorite"config and go to the fbdev menu and select the 
> > backlight option for your fbdev driver.
> 
> 	I would think that we'd always want to enable the backlight.
> How are people supposed to Just Know that the kernel defaults to a black
> LCD?

I just tested various confirations of backlight support. Backlight is 
ALWAYS selected by default when you select a particular fbdev driver that 
has backlight support. You just have the option to turn it off if you 
want. These problems are showing up because of stale .config files.

