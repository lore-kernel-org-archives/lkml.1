Return-Path: <linux-kernel-owner+w=401wt.eu-S2992438AbXCBNjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992438AbXCBNjk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 08:39:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992437AbXCBNjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 08:39:40 -0500
Received: from smtp-105-friday.noc.nerim.net ([62.4.17.105]:2065 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992434AbXCBNjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 08:39:39 -0500
Date: Fri, 2 Mar 2007 14:37:20 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Dave Jones <davej@redhat.com>, Chuck Ebbert <cebbert@redhat.com>,
       Rudolf Marek <r.marek@assembler.cz>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
Message-Id: <20070302143720.cfd8afeb.khali@linux-fr.org>
In-Reply-To: <20070302113158.GC2156@elf.ucw.cz>
References: <45D5EA88.7090300@redhat.com>
	<45D6DDCE.5050803@assembler.cz>
	<45D7461A.2040808@redhat.com>
	<20070218183805.5a4fd813.khali@linux-fr.org>
	<20070228213803.GA4877@ucw.cz>
	<20070301152655.f232db64.khali@linux-fr.org>
	<20070301174806.GA4979@redhat.com>
	<20070302122736.f14a7a22.khali@linux-fr.org>
	<20070302113158.GC2156@elf.ucw.cz>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2007 12:31:58 +0100, Pavel Machek wrote:
> > My point (which you didn't quote) was that there is no correlation
> > between the SMBus being hidden and ACPI accessing the hardware
> > monitoring chip, contrary to what Pavel was suggesting.
> 
> It may not be correlated with ACPI, but BIOS authors clearly want to
> keep you away from their SMBus controllers....

drivers/pci/quirks.c is full of things we do against the BIOS authors
intent. You don't plan to remove them all, do you?

(And as a side note, this is really the board's owner SMBus controller.
The hardware doesn't belong to the BIOS author.)

-- 
Jean Delvare
