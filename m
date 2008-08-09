Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705AbYHIXgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbYHIXgV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 19:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753675AbYHIXgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 19:36:12 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:60327 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbYHIXgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 19:36:10 -0400
Date: Sun, 10 Aug 2008 02:36:01 +0300
From: Felipe Balbi <me@felipebalbi.com>
To: Frans Pop <elendil@planet.nl>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [00/03] [RFC] USB debugging rework
Message-ID: <20080809233600.GC7574@frodo>
Reply-To: me@felipebalbi.com
References: <20080809013820.GA10910@kroah.com> <200808100057.58863.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808100057.58863.elendil@planet.nl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2008 at 12:57:58AM +0200, Frans Pop wrote:
> Greg KH wrote:
> > I've been annoyed for a long time that we make users go off and rebuild
> > their kernels just to enable usb debug messages.  So finally, here's the
> > start of fixing that issue.
> 
> Will your patches also allow to turn off the usb debugging at some point, 
> for example after system boot has been completed if the debugging was 
> only needed to analyze a boot issue?
> 
> I noticed earlier this week that USB debugging will really flood the 
> syslog and had to rebuild my -rc2 kernel without debugging and reboot to 
> get rid of it. AFAICT with your patches only rebooting would be needed, 
> but it would be even nicer if it also could be turned off (and on?) using 
> a sysfs parameter.

no rebooting. Just rmmod and modprobe again with the parameter set to 0,
although a sysfs file would be nice, or maybe allowing the
/sys/module/*/parameters/* to be writable :-)

I think that should be done in driver core.

-- 
balbi
