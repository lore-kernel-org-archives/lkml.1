Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888Ab0CKNlI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 08:41:08 -0500
Received: from cantor.suse.de ([195.135.220.2]:60141 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757873Ab0CKNlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 08:41:04 -0500
Date: Thu, 11 Mar 2010 14:40:57 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Ole Reier Ulland <ole.reier@netcom.no>, linux-kernel@vger.kernel.org
Subject: Re: ZTE MF636 USB modem is not supported
In-Reply-To: <201003111423.58440.linux@rainbow-software.org>
Message-ID: <alpine.LNX.2.00.1003111440000.18642@pobox.suse.cz>
References: <201003110008.58644.ole.reier@netcom.no> <alpine.LRH.2.00.1003111415230.12517@twin.jikos.cz> <201003111423.58440.linux@rainbow-software.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Mar 2010, Ondrej Zary wrote:

> Not sure about MF636, but MF637 works with this udev rule:
> SUBSYSTEM=="usb", SYSFS{idVendor}=="19d2", SYSFS{idProduct}=="2000", RUN+="/usr/sbin/usb_modeswitch --default-vendor 0x19d2 --default-product 0x2000 --message-content 55534243123456782000000080000c85010101180101010101000000000000"

Yes, this works for most of the ZTE modems with exception for 628 IIRC, 
which needs 5553424312345678000000000000061b000000030000000000000000000000 
instead.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
