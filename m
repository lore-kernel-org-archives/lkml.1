Return-Path: <linux-kernel-owner+w=401wt.eu-S1762553AbYA1Vtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762553AbYA1Vtb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 16:49:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753966AbYA1VtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 16:49:22 -0500
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:15135 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752534AbYA1VtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 16:49:21 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAGTcnUd5LBLC/2dsb2JhbACBWKov
X-IronPort-AV: E=Sophos;i="4.25,262,1199626200"; 
   d="scan'208";a="30481590"
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
From: TimC <tconnors@astro.swin.edu.au>
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Mail-Copies-To: tconnors@astro.swin.edu.au
In-reply-to: <20080125180232.GA4613@kroah.com>
References: <20080125180232.GA4613@kroah.com>
X-test-to: Greg KH <greg@kroah.com>
X-cc-to: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
X-reply-to-bofh-messageid: <9PBad-52M-23@gated-at.bofh.it>
X-Editor: emacs-term
X-EndlessSeptember: Tue Sep 5264 08:27:36 EST 1993
X-yes-we-have-no-x-yes-archive-today: NO
X-Face: +*%dmR:3=9i\[:8fga\UgZT#@`f=DU0(wQqI'AR2/r0sBMO}Ax\,V*cWaW-owRlUmuz&=v\KItx0:gRCBg1&z_"4x&-N#Di7))]~p2('`6|5.c3&:Z?VLU`Zt5Kb,~uC6<y}P'~7A+^'|'+iAd4t43:P;tPiT<q=9P$MO]u^@OHn1_4#qP7,XiSo21SkgI`:5=i$,t&uNN_\LfuLyH`)8!:Tb]Z
Message-ID: <slrn-0.9.7.4-9159-5207-200801290827-tc@hexane.ssi.swin.edu.au>
Date: Tue, 29 Jan 2008 08:49:15 +1100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> said on Fri, 25 Jan 2008 10:02:32 -0800:
> FYI, this is a patch that will be sent out in the next round to Linus
> for inclusion in 2.6.25.
> 
> If anyone has any objections about it, please let me know.
> 
> thanks,
> 
> greg k-h
> 
> --------
> 
> From: Greg Kroah-Hartman <gregkh@suse.de>
> Subject: USB: mark USB drivers as being GPL only
> 
> Over two years ago, the Linux USB developers stated that they believed
> there was no way to create a USB kernel driver that was not under the
> GPL.  This patch moves the USB apis to enforce that decision.
> 
> There are no known closed source USB drivers in the wild, so this patch
> should cause no problems.

The near paperweight of Avermedia A828 Hybrid FM Volar nevertheless
works with their closed module[1] at least as a digital tuner and a
pretty crap FM tuner, despite the warning in syslog that it will no
longer work in short order.  Yes, I was suckered in by their claim
that "it works under Linux", wasn't I?

I would have thought it would be fairly easy to write open drivers for
it, given that it has pretty standard chips:
Cypress FX2, WM8739, Conexant CX2584x, Xceive XC3028 and Zarlink MT352




[1] http://www.avermedia.com/EN/default.aspx?TYPE=test.htm&PT=downloadD1&tv_TCAT_POS=0&CATNO0=D&IDX=2.1&CNT=1&CATNO1=D2&PID=471071067-1556&UCN=BAB4C
http://www.avermedia.com/images/www.avermedia.com_EN/A828_LinuxDrv_v0.07_x86Beta.zip
