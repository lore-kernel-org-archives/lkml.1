Return-Path: <linux-kernel-owner+w=401wt.eu-S1756687AbYDAIER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbYDAIER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 04:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753956AbYDAID6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 04:03:58 -0400
Received: from eazy.amigager.de ([213.239.192.238]:43293 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466AbYDAID4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 04:03:56 -0400
Date: Tue, 1 Apr 2008 10:04:38 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>
Subject: Re: 2.6.25-rc6 hangs at resume after suspend to RAM on Mac mini
	Core Duo
Message-ID: <20080401080438.GA9906@dose.home.local>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Pavel Machek <pavel@ucw.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>
References: <20080320060550.GA13200@dose.home.local> <20080331215027.GC3714@elf.ucw.cz> <20080331220151.GA5580@dose.home.local> <200804010017.54799.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804010017.54799.rjw@sisk.pl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2008 at 00:17:53 +0200, Rafael J. Wysocki wrote:
> On Tuesday, 1 of April 2008, Tino Keitel wrote:
> > On Mon, Mar 31, 2008 at 23:50:27 +0200, Pavel Machek wrote:
> > > On Mon 2008-03-31 23:28:12, Tino Keitel wrote:
> > > > On Sat, Mar 29, 2008 at 00:03:15 +0100, Rafael J. Wysocki wrote:
> > > > 
> > > > [...]
> > > > 
> > > > > Can you please try to boot with acpi_new_pts_ordering and retest?
> > > > 
> > > > I just tried current -git (a9edadbf790d72adf6ebed476cb5caf7743e7e4a),
> > > > without success. I still got the same hand at resume.
> > > 
> > > You should put "acpi_new_pts_ordering" on kernel command line.
> > 
> > I did, just forgot to mention it.
> 
> OK, thanks.
> 
> Have you tried to do:
> 
> # echo core > /sys/power/pm_test
> # echo mem > /sys/power/state
> 
> (it's good to boot the kernel with no_console_suspend and do
> "echo 8 > /proc/sys/kernel/printk" before that to see the messages)?

Thanks, I'll try this evening. What should I look for in the kernel
messages?

Regards,
Tino
