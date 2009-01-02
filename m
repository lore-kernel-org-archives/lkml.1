Return-Path: <linux-kernel-owner+w=401wt.eu-S1756988AbZABHBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988AbZABHBg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 02:01:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751900AbZABHBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 02:01:25 -0500
Received: from rtr.ca ([76.10.145.34]:47436 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127AbZABHBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 02:01:25 -0500
Message-ID: <495DBBC1.7040202@rtr.ca>
Date: Fri, 02 Jan 2009 02:01:21 -0500
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
Subject: Re: libusb broken on 2.6.28 x86_64 ?
References: <495DB4AC.50602@rtr.ca>
In-Reply-To: <495DB4AC.50602@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> I'm trying to use 2.6.28 for the first time on an x86_64 box here
> with devices controlled by libusb.  The devices work on the first
> access, but then fail on all subsequent accesses.  Unplugging/replugging
> causes them to work again for a single subsequent access.
> 
> This is with two completely different USB gadgets:
> a VFD alphanumeric display, and an FTDI serial device in bitbang mode.
> 
> Did something break in 2.6.28 for libusb devices ??
..

Mmm.. broken only for 64-bit userspace, it seems.

I've recompiled the same app against 32-bit libs,
and it works just fine on that 64-bit system,
as well as on 32-bit systems.

But not when compiled for pure 64-bit operation on a 64-bit system.

Looks tricky .. must be a change somewhere that assumes
a pointer/long is 32-bits or something.

-ml
