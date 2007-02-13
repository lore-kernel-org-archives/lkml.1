Return-Path: <linux-kernel-owner+w=401wt.eu-S1751638AbXBMS67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638AbXBMS67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 13:58:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbXBMS67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 13:58:59 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:3636 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638AbXBMS66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 13:58:58 -0500
Date: Tue, 13 Feb 2007 13:58:20 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Hasso Tepper <hasso@estpak.ee>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: /proc/sys/net/ipv[46]/conf/ issue unsolved
Message-ID: <20070213185820.GB25362@hmsreliant.homelinux.net>
References: <200702131529.04708.hasso@estpak.ee>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702131529.04708.hasso@estpak.ee>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13, 2007 at 03:29:04PM +0200, Hasso Tepper wrote:
> There is long standing issue in kernel which makes using /etc/sysctl.conf
> useless for boottime configuration of specific interface properties and
> breaks probably any software relying on unconditional existence of the
> conf trees like it was in previous kernels (I alone have written several
> pieces of such software). It's broken AFAIK from 2.6.15. There has been
> several notes about issue in the list, but issue haven't got any (at least
> efficient) attention from developers.
> 
> The current behaviour bites users in many ways and breaks several use cases.
> I asked several times in the past "what I should do now?" question, but
> got no clear answer.
> 
> References:
> http://marc.theaimsgroup.com/?l=linux-netdev&m=115685059625467&w=2
> http://marc.theaimsgroup.com/?l=linux-netdev&m=115690828822486&w=2
> https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=169809
> 
> Is there any chance this will be fixed or at least clear position is
> taken by developers? Breaking userspace applications is declared nonono
> several times in the past ... I'm not even against breaking it if there
> is _very_ good reason to do it. Ok, but I want to know how userspace is
> meant to behave now. I can't continue using crappy workarounds.
> 
Can't this simply be fixed by adding a custom udev rule?  Correct me if I'm
wrong, but the only reason that interfaces come up automatically after their
appropriate module is inserted is because most distos udev rules issue an ifup
$DEVICE when they get a creation event for $DEVICE.  Why not add a custom rule
in for net device creation events to set appropriate sysctl values before the
ifup is issued.

Regards
Neil

> 
> regards,
> 
> -- 
> Hasso Tepper
> -
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
