Return-Path: <linux-kernel-owner+w=401wt.eu-S1752154AbXBEXxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbXBEXxO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 18:53:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbXBEXxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 18:53:14 -0500
Received: from kepler.fjfi.cvut.cz ([147.32.6.11]:45712 "EHLO
	kepler.fjfi.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbXBEXxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 18:53:14 -0500
Date: Tue, 6 Feb 2007 00:53:11 +0100 (CET)
From: Martin Drab <drab@kepler.fjfi.cvut.cz>
To: Keenan Pepper <keenanpepper@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Timeouts on ICH7 PATA drive with ata_piix; ide_generic works
 perfectly
In-Reply-To: <767314830702032132m4172ddfbmb2519ad90e7ae578@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0702060048480.763@kepler.fjfi.cvut.cz>
References: <767314830702032132m4172ddfbmb2519ad90e7ae578@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Feb 2007, Keenan Pepper wrote:

> I just upgraded the kernel on my System76 Gazelle laptop (basically an
> ASUS Z62FP without the Microsoft tax) and the hard drive began
> freezing every few minutes. I blacklisted ata_piix and the problem
> went away, so that really narrows down where the bug has to be. Here's
> the relevant part of the dmesg:
> 
> [  924.000000] ata1.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
> frozen
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

This seems kind of similar to my problems with ICH7 and other SATA on the 
same comp. See <http://bugzilla.kernel.org/show_bug.cgi?id=7883>. I'm 
getting very similar messages.

Martin
