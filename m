Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924AbYCLVYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbYCLVYP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 17:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbYCLVX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 17:23:59 -0400
Received: from twin.jikos.cz ([213.151.79.26]:59409 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbYCLVX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 17:23:58 -0400
Date: Wed, 12 Mar 2008 22:23:46 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Tino Keitel <tino.keitel@gmx.de>
cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       linux-usb@vger.kernel.org
Subject: Re: broken access to a USB HID device after suspend
In-Reply-To: <20080312193405.GA23209@dose.home.local>
Message-ID: <Pine.LNX.4.64.0803122217580.7266@twin.jikos.cz>
References: <20080312193405.GA23209@dose.home.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008, Tino Keitel wrote:

> I use a tool called hidmon to control the parameters of my LCD in shell
> scripts. I just had the case where this tool didn't work after suspend
> to RAM. I just got this error message:
> 
> hid_force_open failed with return code 13
> 
> The kernel log contains lines like this:
> 
> usb 1-1.3: usbfs: USBDEVFS_CONTROL failed cmd hidmon rqt 129 rq 6 len 9 ret -110
> 
> Unplugging and replugging the USB cable of the LCD didn't work.
> However, after a further suspend/resume cycle it works.
> 
> This is Linux 2.6.25-rc5. The behaviour is not repoducible, though.
> However, I just mention it for the case that this might ring a bell
> somewhere.

This in fact looks like a problem with usbdevfs and/or libusb library, not 
the in-kernel HID drvier.

Did this work before? In 2.6.24? 2.6.23? Alan (added to CC, as well as USB 
devel mailinglist) has been doing some changes to usbdevfs to make it 
suspend-aware, if I recall correctly.

-- 
Jiri Kosina
SUSE Labs

