Return-Path: <linux-kernel-owner+w=401wt.eu-S1756514AbYJUWjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514AbYJUWjp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 18:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752437AbYJUWjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 18:39:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55517 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752096AbYJUWjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 18:39:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dmitry Nezhevenko <dion@inhex.net>
Subject: Re: Strange ACPI errors sometimes after resume from s2disk
Date: Wed, 22 Oct 2008 00:44:00 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
References: <20081021220034.GA18248@laptop.local>
In-Reply-To: <20081021220034.GA18248@laptop.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810220044.01259.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding CCs]

On Wednesday, 22 of October 2008, Dmitry Nezhevenko wrote:
> Hiall. Just got these strange messages with 2.6.27.2. They flood dmesg.. (same block every second). 
> 
> [42016.520062] ACPI: EC: acpi_ec_wait timeout, status = 0x1a, event = "b1=0"
> [42016.520079] ACPI: EC: input buffer is not empty, aborting transaction
> [42017.025050] ACPI: EC: acpi_ec_wait timeout, status = 0x1a, event = "b1=0"
> [42017.025197] ACPI: EC: input buffer is not empty, aborting transaction
> [42017.025254] ACPI Exception (evregion-0419): AE_TIME, Returned by Handler for [EmbeddedControl] [20080609]
> [42017.025350] ACPI Error (psparse-0530): Method parse/execution failed [\_SB_.PCI0.SBRG.EC__.BAT1.UPBS] (Node f78353b0), AE_TIME
> [42017.025546] ACPI Error (psparse-0530): Method parse/execution failed [\_SB_.PCI0.SBRG.EC__.BAT1._BST] (Node f7835400), AE_TIME
> [42017.025715] ACPI Exception (battery-0360): AE_TIME, Evaluating _BST [20080609]
> 
> Battery state "freezes" after this.. So if it was charged to 90%, it will
> be 90% forever.  Also information about charger (plugged/unplugged) is not
> updating... BIOS automatically increases display brightness just after
> plugging charger but powersave thinks that it's unplugged.
> 
> After turning laptop off I can't turn it on any more.. I can hear fan noise,
> but it don't boots (There are no even BIOS splash/message)
> 
> I should remove battery and wait ~5 seconds...
> 
> v2.6.26 was non-working here, but as far as I remember, there was no such
> problem with 2.6.25.  It's very difficult to reproduce it (this is just
> second case for ~2-3 weeks).  So bisecting is impossible.
> 
> Any ideas? Should I fill a bugreport?
> 
> dmesg when this happens is available:
> 	http://inhex.net/dion/lkml/dmesg_2.6.27.txt
> 


