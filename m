Return-Path: <linux-kernel-owner+w=401wt.eu-S1758907AbYBXTCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758907AbYBXTCW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 14:02:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbYBXTCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 14:02:00 -0500
Received: from eazy.amigager.de ([213.239.192.238]:44006 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757378AbYBXTB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 14:01:57 -0500
Date: Sun, 24 Feb 2008 20:02:26 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.25-rc2 hangs after "Suspending console(s)"
Message-ID: <20080224190226.GA8209@dose.home.local>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	"Rafael J. Wysocki" <rjw@sisk.pl>
References: <20080218002815.GA4612@dose.home.local> <20080219085222.GA5328@dose.home.local> <20080220072917.GB15866@dose.home.local> <200802232243.51190.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802232243.51190.rjw@sisk.pl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 22:43:50 +0100, Rafael J. Wysocki wrote:
> On Wednesday, 20 of February 2008, Tino Keitel wrote:
> > On Tue, Feb 19, 2008 at 09:52:22 +0100, Tino Keitel wrote:
> > > On Mon, Feb 18, 2008 at 20:49:04 +0100, Pavel Machek wrote:
> > > > On Mon 2008-02-18 01:28:15, Tino Keitel wrote:
> > > > > Hi folks,
> > > > > 
> > > > > with 2.6.25-rc2, my Mac mini Core Duo hangs at suspend. The last
> > > > > message on the console is "Suspending console(s)". I also tried some
> > > > > other versions after 2.6.24, all of them fail with this hang.
> > > > 
> > > > Try adding 'no_console_suspend' to kernel command line.
> > > 
> > > Thanks, that gave a bit insight. The last message is now:
> > > 
> > > ACPI: PCI interrupt for device 0000:00:02.0 disabled
> > > 
> > > This is my graphics card:
> > > 
> > > 00:02.0 VGA compatible controller [0300]: Intel Corporation Mobile
> > > 945GM/GMS, 943/940GML Express Integrated Graphics Controller
> > > 
> > > So it looks like the recent changes that should repair console
> > > sudpend/resume for Intel graphics broke suspend for me.
> > 
> > It looks like I was wrong. It also hangs when the i915 module isn't
> > loaded.
> 
> Please have a look at: http://bugzilla.kernel.org/show_bug.cgi?id=10065

Thanks. I tested git 1a4c6be4aca5ad6b300932efed1e2729fdc25af9 without
any patches and I can suspend and resume fine.

Regards,
Tino
