Return-Path: <linux-kernel-owner+w=401wt.eu-S1756443AbYKCOxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443AbYKCOxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 09:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbYKCOxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 09:53:05 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:36637 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754502AbYKCOxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 09:53:04 -0500
Date: Mon, 3 Nov 2008 09:53:02 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andrey Borzenkov <arvidjaar@mail.ru>
cc: USB list <linux-usb@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.28-rc3: usb_hcd_poll_rh_status: array subscript is above
 array bounds
In-Reply-To: <200811031110.31115.arvidjaar@mail.ru>
Message-ID: <Pine.LNX.4.44L0.0811030952080.2454-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Nov 2008, Andrey Borzenkov wrote:

>   CC [M]  drivers/usb/core/hcd.o
> /home/bor/src/linux-git/drivers/usb/core/hcd.c: In function ‘usb_hcd_poll_rh_status’:
> /home/bor/src/linux-git/arch/x86/include/asm/string_32.h:75: warning: array subscript is above array bounds
> 
> It is likely that issue is actually in string_32.h as similar errors are
> in oher places as well.

I think this is actually a compiler bug.  It certainly has nothing to
do with USB.  There was a discussion about it a month or so ago on
LKML.

Alan Stern

