Return-Path: <linux-kernel-owner+w=401wt.eu-S1750735AbXBMPQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750735AbXBMPQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 10:16:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750738AbXBMPQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 10:16:35 -0500
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:34689 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750735AbXBMPQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 10:16:34 -0500
Date: Tue, 13 Feb 2007 10:16:33 -0500
To: Raphael Assenat <raph@8d.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add PCI device ID for IT8152 RISC-to-PCI chip
Message-ID: <20070213151633.GL7584@csclub.uwaterloo.ca>
References: <45CCD60D.5050001@8d.com> <20070209212856.GK7584@csclub.uwaterloo.ca> <45D1CF22.6010706@8d.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45D1CF22.6010706@8d.com>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13, 2007 at 09:45:54AM -0500, Raphael Assenat wrote:
> Really? I have no idea if it's possible to get a reliable PCI bus or
> not with this chip. Right now, we only use it for it's built-in OHCI 
> USB host controller and UART. You're making me hope I never have to 
> use it for interfacing a PCI card!

Well on the system on a board we were trying, using the development
baseboard from the same supplier, by simply doing a ping flood through
the onboard rtl8139 I managed to get corrupted ethernet packets fairly
frequently.  The WAN cards (T1/E1) we were trying to make work with it
were much more upset by it.  It could be bad enough corruption to cause
the chip on the card and the driver to get out of sync and just have no
idea what to do anymore.  Given our mainboard works perfectly fine using
a Geode SC1200 instead of the PXA255 board, I can only figure the PCI
bus wasn't implemented correctly on that chip, unless PCI on arm is done
wrong in linux (I sure hope not).  There doesn't seem to be very many
arm systems with PCI, so it's hard to tell.  Now other than PCI the
system was wonderful.  Fast, reliable, ran great even at high
temperatures, etc.  Just couldn't get the stupid PCI bus to work.

--
Len Sorensen
