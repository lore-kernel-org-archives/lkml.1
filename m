Return-Path: <linux-kernel-owner+w=401wt.eu-S1751895AbXCEV6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895AbXCEV6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 16:58:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbXCEV6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 16:58:54 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:12905 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbXCEV6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 16:58:53 -0500
Date: Mon, 5 Mar 2007 13:58:17 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com, netdev@vger.kernel.org,
       yi.zhu@intel.com, jketreno@linux.intel.com, akpm@osdl.org
Subject: Re: Recent wireless breakage (ipw2200, iwconfig, NetworkManager)
Message-ID: <20070305215817.GD20528@ca-server1.us.oracle.com>
Mail-Followup-To: linux-kernel@vger.kernel.org, greg@kroah.com,
	netdev@vger.kernel.org, yi.zhu@intel.com, jketreno@linux.intel.com,
	akpm@osdl.org
References: <20070304220857.GH23311@waste.org> <20070305011625.GA7681@kroah.com> <20070305064229.GJ23311@waste.org> <20070305070248.GA30699@kroah.com> <20070305071325.GK23311@waste.org> <20070305154609.GA3626@irc.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070305154609.GA3626@irc.pl>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever come to perfection.
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2007 at 04:46:09PM +0100, Tomasz Torcz wrote:
> On Mon, Mar 05, 2007 at 01:13:26AM -0600, Matt Mackall wrote:
> > That's not the point. The point is that Debian/unstable as of _this
> > morning_ doesn't work. For reference, I'm running both the latest
> > releases of both hal (0.5.8.1-6.1) and network-manager (0.6.4-6). And
> > there are people telling me I need a copy of HAL out of git that
> > hasn't even been released for Debian to package. Debian isn't the
> > problem here.
> 
>   hal 0.5.9-rc1 (released, not from git) should work. It will be
> problably released soon and picked by sane distributions. Debian is very
> irritating corner case.

	As of right now, Fedora Core 6 has hal-0.5.8.1-6.fc6.  This is also
too old.  Please, stop claiming that Debian unstable is some corner
case.  No one is talking about Debian stable here.  No one is talking
about the Enterprise versions of Red Hat or SuSE (you'd find them just
as irritating with modern kernels).  Debian unstable tracks released
code as fast or faster than Fedora and OpenSuSE.  They all keep up with
releases.
	But the last release of hal is 0.5.8.1.  _Release_, not "release
candidate".  You can't break that.  You can't break it for a while, if
you want a sane deprecation schedule.  These are userspace interfaces.
	Matt is absolutely correct that you should't deprecate a
userspace<->kernel interface before you've even provided a release of
the tool that detects the change!

Joel

-- 

"When ideas fail, words come in very handy." 
         - Goethe

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
