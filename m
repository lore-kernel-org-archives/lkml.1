Return-Path: <linux-kernel-owner+w=401wt.eu-S1755658AbXJ2BIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658AbXJ2BIR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 21:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbXJ2BIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 21:08:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55526
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752805AbXJ2BIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 21:08:05 -0400
Date: Sun, 28 Oct 2007 18:08:07 -0700 (PDT)
Message-Id: <20071028.180807.165828961.davem@davemloft.net>
To: gregkh@suse.de
Cc: barak@neocleus.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, guy@neocleus.com
Subject: Re: [PATCH] Align PCI memory regions to page size (4K) - Fix
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071028200336.GA14563@suse.de>
References: <20071028193104.GA13956@suse.de>
	<9392A06CB0FDC847B3A530B3DC174E7B03C96F36@mse10be1.mse10.exchange.ms>
	<20071028200336.GA14563@suse.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@suse.de>
Date: Sun, 28 Oct 2007 13:03:36 -0700

> But doesn't aligning such regions on that alignment break some devices
> as that is not what the device is asking for in the BIOS?

There are also platforms where bootup firmware chooses the
allocations, and that is what we use no matter what.  This is so that
when breaking into the firmware for debugging the firmware can still
access the console device where it had mapped it in the first place.

We really can't do things this way.
