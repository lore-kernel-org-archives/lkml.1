Return-Path: <linux-kernel-owner+w=401wt.eu-S1754655AbYCKUy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbYCKUy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 16:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752151AbYCKUys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 16:54:48 -0400
Received: from 1wt.eu ([62.212.114.60]:2420 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087AbYCKUyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 16:54:47 -0400
Date: Tue, 11 Mar 2008 21:53:41 +0100
From: Willy Tarreau <w@1wt.eu>
To: Daniel Phillips <phillips@phunq.net>
Cc: Chris Friesen <cfriesen@nortel.com>, Lars Marowsky-Bree <lmb@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Grzegorz Kulewski <kangur@polcom.net>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Message-ID: <20080311205340.GJ8953@1wt.eu>
References: <200803092346.17556.phillips@phunq.net> <200803110450.19390.phillips@phunq.net> <47D6C0A8.6010504@nortel.com> <200803111256.51267.phillips@phunq.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803111256.51267.phillips@phunq.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2008 at 11:56:50AM -0800, Daniel Phillips wrote:
> On Tuesday 11 March 2008 10:26, Chris Friesen wrote:
> > I have experienced many 2.6 crashes due to software flaws.  Hung 
> > processes leading to watchdog timeouts, bad kernel pointers, kernel 
> > deadlock, etc.
> > 
> > When designing for reliable embedded systems it's not enough to handwave 
> > away the possibility of software flaws.
> 
> Indeed.  You fix them.  Which 2.6 kernel version failed for you, what
> made it fail, and does the latest version still fail?

Daniel, you're not objective. Simply look at LKML reports. People even
report failures with the stable branch, and that's quite expected when
more than 5000 patches are merged in two weeks. The question could even
be returned to you: what kernel are you using to keep 204 days of uptime
doing all that you describe ? Maybe 2.6.16.x would be fine, but even then,
a lot of security issues have been fixed since the last 204 days (most of
which would require a planned reboot), and also a number of normal bugs,
some of which may cause unexpected downtime.

> If Linux is not reliable then we are doomed and I do not care about
> whether my ramback fails because I will just slit my wrists anyway.

No, I've looked at the violin-memory appliance, and I understand better
your goal. Trying to get a secure and reliable generic kernel is a lost
game. However, building a very specific kernel for an appliance is often
quite achievable, because you know exactly the hardware, usage patterns,
etc... which help you stabilize it. I think people who don't agree with
you are simply thinking about a generic file server. While I would not
like my company's NFS exports to rely on such a technology for the same
concerns as exposed here, I would love to have such a beast for logs
analysis, build farms, or various computations which require more than
an average PC's RAM, and would benefit from the data to remain consistent
across planned downtime.

If you consider that the risk of a crash is 1/year and that you have to
work one day to rebuild everything in case of a crash, it is certainly
worth using this technology for many things. But if you consider that
your data cannot suffer a loss even at a rate of 1/year, then you have
to use something else.

BTW, I would say that IMHO nothing here makes RAID impossible to use :-)
Just wire 2 of these beasts to a central server with 10 Gbps NICs and
you have a nice server :-)

Regards,
Willy

