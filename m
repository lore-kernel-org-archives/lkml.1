Return-Path: <linux-kernel-owner+w=401wt.eu-S1762217AbYDUTot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762217AbYDUTot (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 15:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761732AbYDUToi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 15:44:38 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49980 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762073AbYDUToh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 15:44:37 -0400
Message-ID: <480CEEA2.1040106@firstfloor.org>
Date: Mon, 21 Apr 2008 21:44:34 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Jean Delvare <jdelvare@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Tejun Heo <htejun@gmail.com>,
       Tom Long Nguyen <tom.l.nguyen@intel.com>,
       Randy Dunlap <rdunlap@xenotime.net>, Jeff Garzik <jgarzik@pobox.com>
Subject: Re: PCI MSI breaks when booting with nosmp
References: <200804172140.02311.jdelvare@suse.de> <200804171308.37328.jbarnes@virtuousgeek.org> <200804172225.14373.jdelvare@suse.de> <200804211043.10410.jbarnes@virtuousgeek.org> <87d4oj6o9a.fsf@basil.nowhere.org> <20080421194336.GC32278@elf.ucw.cz>
In-Reply-To: <20080421194336.GC32278@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Mon 2008-04-21 20:45:05, Andi Kleen wrote:
>> Jesse Barnes <jbarnes@virtuousgeek.org> writes:
>>> Ok, I see this too on my desktop machine.  It looks like we're not getting 
>>> interrupts setup correctly in the nosmp case.  Still digging through to see 
>>> why though...
>> NoSMP disables the io-apic and a lot of modern systems don't work
>> without APIC.
> 
> Are you sure? I still boot DOS on very recent boxes, and they seem to
> work. How can PC-compatible machine require an APIC?

The machine doesn't, but the drivers do. DOS likely doesn't use all
hardware.

-Andi
