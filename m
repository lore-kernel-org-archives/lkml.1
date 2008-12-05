Return-Path: <linux-kernel-owner+w=401wt.eu-S1753228AbYLEGpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbYLEGpS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 01:45:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbYLEGpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 01:45:04 -0500
Received: from hpsmtp-eml19.KPNXCHANGE.COM ([213.75.38.84]:45715 "EHLO
	hpsmtp-eml19.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750972AbYLEGpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 01:45:03 -0500
From: Frans Pop <elendil@planet.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken on Toshiba R500 (bisected)
Date: Fri, 5 Dec 2008 07:44:54 +0100
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <alpine.LFD.2.00.0812041845210.3543@nehalem.linux-foundation.org> <alpine.LFD.2.00.0812041917050.3386@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0812041917050.3386@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200812050744.56018.elendil@planet.nl>
X-OriginalArrivalTime: 05 Dec 2008 06:44:59.0481 (UTC) FILETIME=[FE1E8C90:01C956A4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 December 2008, Linus Torvalds wrote:
> Here's a patch that implements what I think is the correct quirks
> (apart from the commented ICH6 lazy detail I didn't do).

I get:
pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 1100-113f claimed by ICH6 GPIO
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0500 (mask 007f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 02e8 (mask 0007)

The ICH6 and ICH7 in those messages is a bit weird given that my system is 
ICH8...

Hardware info (JFYI):
00:1f.0 ISA bridge [0601]: Intel Corporation 82801HBM (ICH8M-E) LPC 
Interface Controller [8086:2811] (rev 03)

System Information
        Manufacturer: Hewlett-Packard
        Product Name: HP Compaq 2510p Notebook PC
        Version: F.0C
Base Board Information
        Manufacturer: Hewlett-Packard
        Product Name: 30C9
        Version: KBC Version 75.28
BIOS Information
        Vendor: Hewlett-Packard
        Version: 68MSP Ver. F.0C
        Release Date: 06/18/2008
