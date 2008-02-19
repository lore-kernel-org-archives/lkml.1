Return-Path: <linux-kernel-owner+w=401wt.eu-S1762182AbYBSIwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762182AbYBSIwc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 03:52:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbYBSIwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 03:52:24 -0500
Received: from eazy.amigager.de ([213.239.192.238]:46148 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbYBSIwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 03:52:24 -0500
Date: Tue, 19 Feb 2008 09:52:22 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc2 hangs after "Suspending console(s)"
Message-ID: <20080219085222.GA5328@dose.home.local>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20080218002815.GA4612@dose.home.local> <20080218194904.GA7115@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080218194904.GA7115@elf.ucw.cz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2008 at 20:49:04 +0100, Pavel Machek wrote:
> On Mon 2008-02-18 01:28:15, Tino Keitel wrote:
> > Hi folks,
> > 
> > with 2.6.25-rc2, my Mac mini Core Duo hangs at suspend. The last
> > message on the console is "Suspending console(s)". I also tried some
> > other versions after 2.6.24, all of them fail with this hang.
> 
> Try adding 'no_console_suspend' to kernel command line.

Thanks, that gave a bit insight. The last message is now:

ACPI: PCI interrupt for device 0000:00:02.0 disabled

This is my graphics card:

00:02.0 VGA compatible controller [0300]: Intel Corporation Mobile
945GM/GMS, 943/940GML Express Integrated Graphics Controller

So it looks like the recent changes that should repair console
sudpend/resume for Intel graphics broke suspend for me.

Regards,
Tino
