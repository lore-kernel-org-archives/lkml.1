Return-Path: <linux-kernel-owner+w=401wt.eu-S1758743AbYB0NMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758743AbYB0NMt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 08:12:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757257AbYB0NMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 08:12:40 -0500
Received: from cavan.codon.org.uk ([78.32.9.130]:43617 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755615AbYB0NMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 08:12:40 -0500
Date: Wed, 27 Feb 2008 13:12:27 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Dave Jones <davej@codemonkey.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>
Message-ID: <20080227131227.GB28528@srcf.ucam.org>
References: <20080225225820.GP2659@elf.ucw.cz> <20080225155550.4a020dfb.akpm@linux-foundation.org> <20080226000007.GB22102@atrey.karlin.mff.cuni.cz> <20080226101117.GA26671@atrey.karlin.mff.cuni.cz> <20080226174613.GA26259@codemonkey.org.uk> <20080226175954.GA5707@elf.ucw.cz> <20080226181001.GA7714@codemonkey.org.uk> <20080226181611.GB6030@elf.ucw.cz> <20080226182241.GB7714@codemonkey.org.uk> <20080226215641.GE10280@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226215641.GE10280@elf.ucw.cz>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: broken suspend in .2.6.25-rc3 on T61p (was Re: new regression in 2.6.25-rc3: no keyboard/lid acpi events on thinkpad T61p)
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 10:56:41PM +0100, Pavel Machek wrote:

> Seems like pm-utils is just a thin wrapper around s2ram, at least in
> version debian ships. It does not seem to have its own whitelist.

That's a Debian patch.

> ...so it is ready to use s2ram, but will fall back to
> echo. Unfortunately, that will mean no video resume on _many_
> machines.

See /usr/lib/pm-utils/sleep.d/99video .

> Pretty please, can we get s2ram for Fedora, so that video is restored
> there?

Stefan told us at FOSDEM that s2ram was being deprecated in OpenSuse, so 
I don't think this is the way to go.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
