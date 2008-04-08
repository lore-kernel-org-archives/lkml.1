Return-Path: <linux-kernel-owner+w=401wt.eu-S1754925AbYDHI66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925AbYDHI66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 04:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbYDHI6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 04:58:50 -0400
Received: from eazy.amigager.de ([213.239.192.238]:37340 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbYDHI6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 04:58:49 -0400
Date: Tue, 8 Apr 2008 10:58:46 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Romano Giannetti <romanol@upcomillas.es>,
       Soeren Sonnenburg <kernel@nn7.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bugme-daemon@bugzilla.kernel.org, Jesse Barnes <jesse.barnes@intel.com>,
       suspend-devel@lists.sourceforge.net
Subject: Re: 2.6.25-rc6 regression - hang on resume [Bug 10319]
Message-ID: <20080408085846.GA15403@dose.home.local>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Romano Giannetti <romanol@upcomillas.es>,
	Soeren Sonnenburg <kernel@nn7.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	bugme-daemon@bugzilla.kernel.org,
	Jesse Barnes <jesse.barnes@intel.com>,
	suspend-devel@lists.sourceforge.net
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik> <1207290689.4511.1.camel@localhost> <1207552602.26185.13.camel@pern> <200804071110.39933.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804071110.39933.rjw@sisk.pl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2008 at 11:10:39 +0200, Rafael J. Wysocki wrote:
> On Monday, 7 of April 2008, Romano Giannetti wrote:
> > 
> > On Fri, 2008-04-04 at 08:31 +0200, Soeren Sonnenburg wrote:
> > > On Fri, 2008-04-04 at 01:22 +0200, Rafael J. Wysocki wrote:
> >>
> > > Yes. The machine resumes and display stays black using s2ram -f -p
> > > (blindly typing reboot etc on keyboard does what is expected). However
> > > display comes back on 2.6.24.
> > 
> > I can add that on my laptop (toshiba U305, Intel 945GM chipset), s2ram
> > -f -p -m which used to work ok, in X and console, in 2.6.24 stopped to
> > work (I tested -rc8, but I think it's like that since a long time).
> > Machine resumes but the screen stays off after that, although machine is
> > working (exactly as Soeren said).
> 
> Your graphics adapter is different from the Soeren's one and the fact that
> "echo mem > /sys/power/state" works for you now is probably a result of the
> recent changes in the i915 driver that is now supposed to handle suspend
> and resume.

I tried to use vbetool to get my text console back with 2.6.24 after a
suspend to RAM. As a result, I got a text working console, but a
crashing X server sometimes after resume, and the only way to get X
back was to reboot.

With 2.6.25-rc, the text console is fine after resume, due to the
recent changes to the Intel i915 DRM driver. Maybe those people who
used to use vbetool prior to 2.6.25 should check if this is still
needed.

Regards,
Tino
