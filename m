Return-Path: <linux-kernel-owner+w=401wt.eu-S1756362AbYDRJlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362AbYDRJlq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 05:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754380AbYDRJlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 05:41:37 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:58400 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289AbYDRJlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 05:41:36 -0400
Date: Fri, 18 Apr 2008 11:42:21 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-pm@lists.linux-foundation.org, Greg KH <greg@kroah.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.25-mm1: not looking good
Message-ID: <20080418094220.GB23572@elf.ucw.cz>
References: <20080417160331.b4729f0c.akpm@linux-foundation.org> <20080418005034.6e4dd9e7.akpm@linux-foundation.org> <20080418005323.7c015c42.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080418005323.7c015c42.akpm@linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-04-18 00:53:23, Andrew Morton wrote:
> On Fri, 18 Apr 2008 00:50:34 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > dmesg: http://userweb.kernel.org/~akpm/x.txt
> > config: http://userweb.kernel.org/~akpm/config-t61p.txt
> 
> oop, there's more:
> 
> 
> sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> firewire_core: created device fw0: GUID 00016c2000174bad, S400
> PM: Device usb4 failed to restore: error -113
> eth0: Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
> eth0: 10/100 speed: disabling TSO
> PM: Device usb5 failed to restore: error -113
> PM: Device usb7 failed to restore: error -113
> sd 0:0:0:0: [sda] Starting disk
> PM: Image restored successfully.
> Restarting tasks ... done.
> PM: Basic memory bitmaps freed
> 
> Those USB restore failures are new.  They're similar to the ones on the
> doesnt-resume-properly-any-more Vaio.  They came out from the machine's
> second (successful) resume-from-disk.

Try rmmod usb / insmod usb around suspend to see if it is
usb-specific, or if something went seriously wrong in core.

Or you might just bisect it ;-).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
