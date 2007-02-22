Return-Path: <linux-kernel-owner+w=401wt.eu-S965227AbXBVCKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965227AbXBVCKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 21:10:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965233AbXBVCKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 21:10:43 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:17796 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965227AbXBVCKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 21:10:42 -0500
Date: Wed, 21 Feb 2007 18:09:51 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: James Simmons <jsimmons@infradead.org>
Cc: Yaroslav Halchenko <lists@onerussian.com>,
       Richard Purdie <rpurdie@rpsys.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] no backlight on radeon after recent kernel "upgrade"s
Message-ID: <20070222020951.GR7920@ca-server1.us.oracle.com>
Mail-Followup-To: James Simmons <jsimmons@infradead.org>,
	Yaroslav Halchenko <lists@onerussian.com>,
	Richard Purdie <rpurdie@rpsys.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fbdev-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
References: <20070219044616.GC25659@washoe.onerussian.com> <20070219000412.acad13de.akpm@linux-foundation.org> <1171876788.6046.3.camel@localhost.localdomain> <20070221055648.GM25659@washoe.onerussian.com> <Pine.LNX.4.64.0702220109450.17121@pentafluge.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702220109450.17121@pentafluge.infradead.org>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever come to perfection.
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 22, 2007 at 01:11:18AM +0000, James Simmons wrote:
> > *$> grep BACKLIGH /boot/config-2.6.20 
> > # CONFIG_FB_BACKLIGHT is not set
> > CONFIG_BACKLIGHT_LCD_SUPPORT=y
> > CONFIG_BACKLIGHT_CLASS_DEVICE=m
> > CONFIG_BACKLIGHT_DEVICE=y
> 
> You need to explictly enable the backlight for your fbdev driver. It 
> doesn't do the selecting magically for you.
> Jus do a make "favorite"config and go to the fbdev menu and select the 
> backlight option for your fbdev driver.

	I would think that we'd always want to enable the backlight.
How are people supposed to Just Know that the kernel defaults to a black
LCD?

Joel


-- 

Life's Little Instruction Book #407

	"Every once in a while, take the scenic route."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
