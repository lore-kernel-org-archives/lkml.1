Return-Path: <linux-kernel-owner+w=401wt.eu-S1757208AbZABHv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208AbZABHv0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 02:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbZABHvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 02:51:16 -0500
Received: from rtr.ca ([76.10.145.34]:48309 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841AbZABHvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 02:51:15 -0500
Message-ID: <495DC771.9030103@rtr.ca>
Date: Fri, 02 Jan 2009 02:51:13 -0500
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: libusb broken on 2.6.28 x86_64 ?
References: <495DB4AC.50602@rtr.ca> <495DBBC1.7040202@rtr.ca> <20090102072436.GA3444@suse.de>
In-Reply-To: <20090102072436.GA3444@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Fri, Jan 02, 2009 at 02:01:21AM -0500, Mark Lord wrote:
>> Mark Lord wrote:
..
>> Mmm.. broken only for 64-bit userspace, it seems.
>>
>> I've recompiled the same app against 32-bit libs,
>> and it works just fine on that 64-bit system,
>> as well as on 32-bit systems.
>>
>> But not when compiled for pure 64-bit operation on a 64-bit system.
..
> Which version of libusb, a new one was just released a few weeks ago
> that fixes a lot of problems reported in the older libusb versions, and
> made things much faster to boot.  You might want to check it out.
..

This is with libusb-0.1-4, which has been working fine with all prior kernels,
including the 2.6.27.xx series.

Userspace stuff like this is not supposed to be broken from kernel to kernel.

Cheers
