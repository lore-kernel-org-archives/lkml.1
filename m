Return-Path: <linux-kernel-owner+w=401wt.eu-S1757190AbZABH0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190AbZABH0o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 02:26:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbZABH0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 02:26:35 -0500
Received: from ns1.suse.de ([195.135.220.2]:42948 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127AbZABH0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 02:26:34 -0500
Date: Thu, 1 Jan 2009 23:24:36 -0800
From: Greg KH <gregkh@suse.de>
To: Mark Lord <lkml@rtr.ca>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: libusb broken on 2.6.28 x86_64 ?
Message-ID: <20090102072436.GA3444@suse.de>
References: <495DB4AC.50602@rtr.ca> <495DBBC1.7040202@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <495DBBC1.7040202@rtr.ca>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2009 at 02:01:21AM -0500, Mark Lord wrote:
> Mark Lord wrote:
>> I'm trying to use 2.6.28 for the first time on an x86_64 box here
>> with devices controlled by libusb.  The devices work on the first
>> access, but then fail on all subsequent accesses.  Unplugging/replugging
>> causes them to work again for a single subsequent access.
>> This is with two completely different USB gadgets:
>> a VFD alphanumeric display, and an FTDI serial device in bitbang mode.
>> Did something break in 2.6.28 for libusb devices ??
> ..
>
> Mmm.. broken only for 64-bit userspace, it seems.
>
> I've recompiled the same app against 32-bit libs,
> and it works just fine on that 64-bit system,
> as well as on 32-bit systems.
>
> But not when compiled for pure 64-bit operation on a 64-bit system.
>
> Looks tricky .. must be a change somewhere that assumes
> a pointer/long is 32-bits or something.

Which version of libusb, a new one was just released a few weeks ago
that fixes a lot of problems reported in the older libusb versions, and
made things much faster to boot.  You might want to check it out.

Hope this helps,

greg k-h
