Return-Path: <linux-kernel-owner+w=401wt.eu-S1759342AbYDVVZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759342AbYDVVZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 17:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbYDVVZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 17:25:19 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:46112 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbYDVVZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 17:25:18 -0400
Date: Tue, 22 Apr 2008 23:25:48 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Jean Delvare <jdelvare@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Tejun Heo <htejun@gmail.com>,
       Tom Long Nguyen <tom.l.nguyen@intel.com>,
       Randy Dunlap <rdunlap@xenotime.net>, Jeff Garzik <jgarzik@pobox.com>
Subject: Re: PCI MSI breaks when booting with nosmp
Message-ID: <20080422212548.GC6004@elf.ucw.cz>
References: <200804172140.02311.jdelvare@suse.de> <200804171308.37328.jbarnes@virtuousgeek.org> <200804172225.14373.jdelvare@suse.de> <200804211043.10410.jbarnes@virtuousgeek.org> <87d4oj6o9a.fsf@basil.nowhere.org> <20080421194336.GC32278@elf.ucw.cz> <480CEEA2.1040106@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480CEEA2.1040106@firstfloor.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-04-21 21:44:34, Andi Kleen wrote:
> Pavel Machek wrote:
> > On Mon 2008-04-21 20:45:05, Andi Kleen wrote:
> >> Jesse Barnes <jbarnes@virtuousgeek.org> writes:
> >>> Ok, I see this too on my desktop machine.  It looks like we're not getting 
> >>> interrupts setup correctly in the nosmp case.  Still digging through to see 
> >>> why though...
> >> NoSMP disables the io-apic and a lot of modern systems don't work
> >> without APIC.
> > 
> > Are you sure? I still boot DOS on very recent boxes, and they seem to
> > work. How can PC-compatible machine require an APIC?
> 
> The machine doesn't, but the drivers do. DOS likely doesn't use all
> hardware.

Should we be fixing drivers?

Do drivers even know? I'd expect core code in arch/x86 to shield
details of interrupt routing from them..

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
