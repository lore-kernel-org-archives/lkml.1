Return-Path: <linux-kernel-owner+w=401wt.eu-S1030400AbXCCVNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030400AbXCCVNH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 16:13:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030424AbXCCVNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 16:13:07 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:46624 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030400AbXCCVNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 16:13:05 -0500
Date: Sat, 3 Mar 2007 22:13:32 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] bcm43xx: do not rebuild when kernel version changes
Message-ID: <20070303211332.GA31321@uranus.ravnborg.org>
References: <20070303190328.GA30463@uranus.ravnborg.org> <200703032121.43136.mb@bu3sch.de> <45E9E2BD.9070106@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45E9E2BD.9070106@lwfinger.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 03, 2007 at 03:03:57PM -0600, Larry Finger wrote:
> Michael Buesch wrote:
> > On Saturday 03 March 2007 20:03, Sam Ravnborg wrote:
> >> Replacing use of UTS_RELEASE with utsname()->release
> >> avoids that this module is rebuild each
> >> time the kernel version changes.
> >>
> >> Compile tested only.
> > 
> > I vote to get rid of the whole bcm43xx_ethtool.c file, as it's useless.
> > It will vanish with the advent of d80211, anyway.
> > Larry?
> 
> Is bcm43xx_ethtool.c really useless? If so, I vote to remove it. I have never tried to use ethtool
> on bcm43xx. Similarly, it isn't very often that I recompile the kernel when bcm43xx hasn't changed
> and would not have noticed the bug that Sam reported.
I saw it only because I tossed around with a allmodconfig build.
I do not care if it is fixed one way or the other - but I like that
only relevant parts are rebuild when kernel version changes.

	Sam
