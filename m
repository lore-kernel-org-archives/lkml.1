Return-Path: <linux-kernel-owner+w=401wt.eu-S1763680AbYBWVpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763680AbYBWVpm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 16:45:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756480AbYBWVpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 16:45:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50198 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756360AbYBWVpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 16:45:35 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tino Keitel <tino.keitel@gmx.de>
Subject: Re: 2.6.25-rc2 hangs after "Suspending console(s)"
Date: Sat, 23 Feb 2008 22:43:50 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
References: <20080218002815.GA4612@dose.home.local> <20080219085222.GA5328@dose.home.local> <20080220072917.GB15866@dose.home.local>
In-Reply-To: <20080220072917.GB15866@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802232243.51190.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 20 of February 2008, Tino Keitel wrote:
> On Tue, Feb 19, 2008 at 09:52:22 +0100, Tino Keitel wrote:
> > On Mon, Feb 18, 2008 at 20:49:04 +0100, Pavel Machek wrote:
> > > On Mon 2008-02-18 01:28:15, Tino Keitel wrote:
> > > > Hi folks,
> > > > 
> > > > with 2.6.25-rc2, my Mac mini Core Duo hangs at suspend. The last
> > > > message on the console is "Suspending console(s)". I also tried some
> > > > other versions after 2.6.24, all of them fail with this hang.
> > > 
> > > Try adding 'no_console_suspend' to kernel command line.
> > 
> > Thanks, that gave a bit insight. The last message is now:
> > 
> > ACPI: PCI interrupt for device 0000:00:02.0 disabled
> > 
> > This is my graphics card:
> > 
> > 00:02.0 VGA compatible controller [0300]: Intel Corporation Mobile
> > 945GM/GMS, 943/940GML Express Integrated Graphics Controller
> > 
> > So it looks like the recent changes that should repair console
> > sudpend/resume for Intel graphics broke suspend for me.
> 
> It looks like I was wrong. It also hangs when the i915 module isn't
> loaded.

Please have a look at: http://bugzilla.kernel.org/show_bug.cgi?id=10065

Thanks,
Rafael
