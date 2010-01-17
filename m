Return-Path: <linux-kernel-owner+w=401wt.eu-S1754770Ab0AQXTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab0AQXTo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 18:19:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754318Ab0AQXTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 18:19:43 -0500
Received: from eazy.amigager.de ([213.239.192.238]:58171 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139Ab0AQXTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 18:19:42 -0500
Date: Mon, 18 Jan 2010 00:19:32 +0100
From: Tino Keitel <tino.keitel@tikei.de>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: Regression: Wake on LAN doesn't work in sky2 with
 2.6.33-rc4-git2
Message-ID: <20100117231932.GA5504@mac.home>
Mail-Followup-To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Stephen Hemminger <shemminger@vyatta.com>
References: <20100115091053.GA5477@mac.home>
 <20100115105059.251a3717@nehalam>
 <201001152323.37718.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001152323.37718.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 15, 2010 at 23:23:37 +0100, Rafael J. Wysocki wrote:
> On Friday 15 January 2010, Stephen Hemminger wrote:

[...]

> > This has already been reported.
> > 
> > Rafael has been doing the generic PM stuff.
> > Look for thread,
> >  [Bug 14730] sky2 won't work after suspend/resume cycle
> 
> This has been fixed already and the bug appears to be different.

Yes, sounds different. The interface works after a resume. My issue is
that the computer just won't resume at all using wake on LAN.

> 
> No idea what it is at the moment.
> 
> Tino, please check if reverting commit
> dc1a94ae1749d14c55f8b54e9d92bd89df82d51a helps, although the messages
> indicate that the generic PCI-side does its job.

No luck with the commit reverted, WoL still doesn't work.

Regards,
Tino
