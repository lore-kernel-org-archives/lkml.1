Return-Path: <linux-kernel-owner+w=401wt.eu-S1752538AbXIUAlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538AbXIUAlE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 20:41:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754594AbXIUAkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 20:40:53 -0400
Received: from outbound-mail-16.bluehost.com ([69.89.20.231]:53774 "HELO
	outbound-mail-16.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752129AbXIUAkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 20:40:52 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Lossy interrupts on x86_64
Date: Thu, 20 Sep 2007 17:40:48 -0700
User-Agent: KMail/1.9.7
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
References: <200709120833.15980.jbarnes@virtuousgeek.org> <200709201222.55278.jbarnes@virtuousgeek.org> <1190317818.3053.1.camel@chaos>
In-Reply-To: <1190317818.3053.1.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709201740.49339.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.103.130.182 authed with jbarnes@virtuousgeek.org}
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box128.bluehost.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [642 0] / [47 12]
X-AntiAbuse: Sender Address Domain - virtuousgeek.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 20, 2007, Thomas Gleixner wrote:
> On Thu, 2007-09-20 at 12:22 -0700, Jesse Barnes wrote:
> > > Eeek, that sounds scary. Can you add "highres=off" as well ?
> >
> > FWIW I just tried your linux-2.6-hires tree with the attached
> > config and still see the problem.  It doesn't look like NO_HZ is
> > even an option in that tree...
>
> Right, that's a 2.6-hrt update tree for Linus to pull. The 64 bit
> parts are not in there. It's basically Linus + some fixes.

Arg, looks like this is actually a DRM problem, but it doesn't exist in 
the DRM upstream tree, only the upstream kernel tree.  I've only seen 
it on 965 chips though, and they have other vblank related problems, so 
I won't worry about it for 2.6.23 proper.

Thanks,
Jesse
