Return-Path: <linux-kernel-owner+w=401wt.eu-S1759506AbYDMRDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759506AbYDMRDS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 13:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754333AbYDMRDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 13:03:10 -0400
Received: from crypt.ethx.net ([82.165.27.140]:55124 "EHLO crypt.ethx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415AbYDMRDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 13:03:09 -0400
Subject: Re: Samsung Q45 hard freeze during boot
From: Sam Morris <sam@robots.org.uk>
To: linux-kernel@vger.kernel.org
In-Reply-To: <1207875044.4594.2.camel@xerces>
References: <1207823931.8277.10.camel@tycho.robots.org.uk>
	 <1207875044.4594.2.camel@xerces>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sun, 13 Apr 2008 18:02:58 +0100
Message-Id: <1208106178.4774.0.camel@durandal>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-Spam-Bars: /
X-Spam-Report: hits=0.2: ALL_TRUSTED=-1.44, TVD_RCVD_IP=1.617 with SpamAssassin 3.2.3 (2007-08-08) on crypt.ethx.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-11 at 01:50 +0100, Sam Morris wrote:
> On Thu, 2008-04-10 at 11:38 +0100, Sam Morris wrote:
> > Hi there, I'm trying to get Linux working on a Samsung Q45 laptop.
> > 2.6.22 works fine, but 2.6.24.3 and 2.6.25-rc8 both freeze hard during
> > boot time after the following messages:
> > 
> >         Waiting for /dev to be fully populated...
> >         agpgart: Detected an Intel 965GM Chipset.
> >         agpgart: AGP aperture is 256M @ 0xd0000000
> >         input: Power Button (FF) as /class/input/input2
> >         ACPI: Power Button (FF) [PWSRF]
> >         inputL Lid Switch as /class/input/input3
> >         ACPI: Lid Switch [LID0]
> >         input: Power Button (CM) as /class/input/input4
> >         ACPI: Power Button (CM) [PWRB]
> >         input: Sleep Button (CM) as /class/input/input5
> >         ACPI: Sleep Button (CM) [SLPB]
> >         ACPI: AC Adapter [ADP1] (on-line)
> >         ACPI: Battery Slot [BAT1] (battery present)
> 
> Further to this--I found that if I blacklist the 'video' driver then I can boot up normally.

I built a mainline kernel to test this out, and the freeze happens with
2.6.24.4. I also filed a bug at
<http://bugzilla.kernel.org/show_bug.cgi?id=10448>.

-- 
Sam Morris <sam@robots.org.uk>
