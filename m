Return-Path: <linux-kernel-owner+w=401wt.eu-S1751020AbXBUF46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751020AbXBUF46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 00:56:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751129AbXBUF46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 00:56:58 -0500
Received: from washoe.rutgers.edu ([165.230.95.67]:48925 "EHLO
	smtp.onerussian.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbXBUF45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 00:56:57 -0500
Date: Wed, 21 Feb 2007 00:56:48 -0500
From: Yaroslav Halchenko <lists@onerussian.com>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net
Message-ID: <20070221055648.GM25659@washoe.onerussian.com>
Mail-Followup-To: Richard Purdie <rpurdie@rpsys.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-fbdev-devel@lists.sourceforge.net
References: <20070219044616.GC25659@washoe.onerussian.com> <20070219000412.acad13de.akpm@linux-foundation.org> <1171876788.6046.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171876788.6046.3.camel@localhost.localdomain>
X-URL: http://www.onerussian.com
X-Image-Url: http://www.onerussian.com/img/yoh.png
X-PGP-Key: http://www.onerussian.com/gpg-yoh.asc
X-fingerprint: 3BB6 E124 0643 A615 6F00  6854 8D11 4563 75C0 24C8
User-Agent: mutt-ng/devel-r804 (Debian)
X-SA-Exim-Connect-IP: 192.168.100.6
X-SA-Exim-Rcpt-To: rpurdie@rpsys.net, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net
X-SA-Exim-Mail-From: yoh@washoe.rutgers.edu
Subject: Re: no backlight on radeon after recent kernel "upgrade"s
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on smtp.onerussian.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am sorry on the delay

> > On Sun, 18 Feb 2007 23:46:16 -0500 Yaroslav Halchenko <kernel@onerussian.com> wrote:
> > > Since the most recent successful for me kernel 2.6.19-rc6-mm1, I've
> > > tried few times to build more recent snapshots and now finally
> > > 2.6.20-mm2. In all those cases I have a sad outcome -- kernel boots but
> > > >...<
> > Is 2.6.20 broken?  I assume the latest 2.6.20-gitN snapshot are failing..
-mm's have been failing since some time after .19-rc6-mm1. I believe
I've tried 2.6.19-mm? with the same luck

> It would be extremely useful to know which kernel versions you tested
> and which ones failed. There are a number of backlight changes which are
> just in 2.6.20-mm1 and -mm2 which it would be useful to rule out or
> identify as the cause.
I didn't mention 2.6.20-mm1 and got to see -mm2 so it is the one which
Iv'e tried, but, once again, I experienced the same issue with 19-mm?
kernels.

I built 2.6.20-mm2 without backlight support
$> grep BACKLIGH /boot/config-2.6.20-mm2 
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
# CONFIG_FB_BACKLIGHT is not set
# CONFIG_FB_RIVA_BACKLIGHT is not set
# CONFIG_FB_RADEON_BACKLIGHT is not set

that "eliminated" the problem. Also I can see the screen with pure
2.6.20 with backlight support (whatever it does since after
loading lcd, backlight modules, my /sys/class/{lcd,backlight} are empty):

*$> grep BACKLIGH /boot/config-2.6.20 
# CONFIG_FB_BACKLIGHT is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_BACKLIGHT_CLASS_DEVICE=m
CONFIG_BACKLIGHT_DEVICE=y


> Also, do you normally see files under /sys/class/lcd?
nope... after I load lcd module, no files under :-/ regardless either it
is mm or not. But there are files under /sys/class/backlight/ for mm2
compiled with backlight support (whenever the screen is dark as per my
original email)

-- 
                                  .-.
=------------------------------   /v\  ----------------------------=
Keep in touch                    // \\     (yoh@|www.)onerussian.com
Yaroslav Halchenko              /(   )\               ICQ#: 60653192
                   Linux User    ^^-^^    [175555]


