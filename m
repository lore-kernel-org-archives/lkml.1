Return-Path: <linux-kernel-owner+w=401wt.eu-S1752119AbXBDGiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbXBDGiQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 01:38:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbXBDGiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 01:38:16 -0500
Received: from smtp.osdl.org ([65.172.181.24]:60154 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752119AbXBDGiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 01:38:16 -0500
Date: Sat, 3 Feb 2007 22:38:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Keenan Pepper" <keenanpepper@gmail.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: Timeouts on ICH7 PATA drive with ata_piix; ide_generic works
 perfectly
Message-Id: <20070203223803.89c969ed.akpm@linux-foundation.org>
In-Reply-To: <767314830702032132m4172ddfbmb2519ad90e7ae578@mail.gmail.com>
References: <767314830702032132m4172ddfbmb2519ad90e7ae578@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Feb 2007 00:32:12 -0500 "Keenan Pepper" <keenanpepper@gmail.com> wrote:

> I just upgraded the kernel on my System76 Gazelle laptop (basically an
> ASUS Z62FP without the Microsoft tax) and the hard drive began
> freezing every few minutes. I blacklisted ata_piix and the problem
> went away, so that really narrows down where the bug has to be. Here's
> the relevant part of the dmesg:
> 
> [  924.000000] ata1.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> [  924.000000] ata1.01: cmd a0/01:00:00:00:00/00:00:00:00:00/b0 tag 0
> cdb 0x25 data 8 in
> [  924.000000]          res 40/00:03:00:00:00/00:00:00:00:00/b0 Emask
> 0x4 (timeout)
> [  931.004000] ata1: port is slow to respond, please be patient (Status 0xd0)
> [  954.028000] ata1: port failed to respond (30 secs, Status 0xd0)
> [  954.028000] ata1: soft resetting port
> [  954.380000] ata1.00: configured for UDMA/100
> [  954.560000] ata1.01: configured for UDMA/33
> [  954.560000] ata1: EH complete

>From what version of the kernel did you upgrade?

It is very helpful for us to knwo the latest version which worked OK.

> Complete dmesg and lspci -vvx are attached; please CC me because I'm
> not subscribed. My sincere apologies if this is already fixed in the
> main kernel.

You're running 2.6.20-rc6.  This won't have been fixed.
