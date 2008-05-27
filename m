Return-Path: <linux-kernel-owner+w=401wt.eu-S1756187AbYE0BIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbYE0BIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 21:08:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754578AbYE0BHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 21:07:55 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34858 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272AbYE0BHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 21:07:54 -0400
Date: Tue, 27 May 2008 10:13:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Pavel Machek <pavel@suse.cz>
Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ACPI: add DMI info to enable OSI(Linux) on
 PRIMEQUEST
Message-Id: <20080527101302.4bd49e6c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080526080614.GA28147@elf.ucw.cz>
References: <4816F9B9.3090609@jp.fujitsu.com>
	<4836660B.3080406@jp.fujitsu.com>
	<483667A4.9000606@jp.fujitsu.com>
	<20080525114308.GA5237@ucw.cz>
	<483A6D15.6030701@jp.fujitsu.com>
	<20080526080614.GA28147@elf.ucw.cz>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 May 2008 10:06:14 +0200
Pavel Machek <pavel@suse.cz> wrote:

> On Mon 2008-05-26 16:56:05, Taku Izumi wrote:
> >
> > Thank you for your response.
> >
> >>> This patch adds DMI info to enable OSI(Linux) on PRIMEQUEST.
> >>> (PRIMEQUEST is ia64 machine.)
> >>
> >> Why is it needed? Why needs your bios know whether it is Linux or BSD
> >> or whatver running?
> >
> >   For memory hotplug support.
> >   Memory hotplug doesn't work on PRIMEQUEST when OSI(Linux) is disabled.
> 
> So fix the BIOS: there's no reason why memory hotplug should not work
> on BSD or Windows...
> 									Pavel
IIRC, PrimeQuest doesn't support BSD ;)

It's not really for memory hotplug. The result of _OSI method (TOOS) is
used for PCI, EC driver's behavior, etc.. (on my box) 

BTW, PrimeQuest's firmware is designed in 2.6.18 age and _heavily_ tested under
_OSI("Linux") environments. So, the acpi layer which returns _OSI("Linux") 
is valid for PrimeQuest. I don't hear a major firmware update for
already-sold-hosts is scheduled.

Thanks,
-Kame

