Return-Path: <linux-kernel-owner+w=401wt.eu-S1422905AbXBAOW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422905AbXBAOW3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 09:22:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422904AbXBAOW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 09:22:29 -0500
Received: from javad.com ([216.122.176.236]:4221 "EHLO javad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422905AbXBAOW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 09:22:29 -0500
From: Sergei Organov <osv@javad.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com>
	<20070130191020.GF20642@kroah.com> <87fy9r2ixc.fsf@javad.com>
	<20070201054644.GD5979@kroah.com>
Date: Thu, 01 Feb 2007 17:22:20 +0300
In-Reply-To: <20070201054644.GD5979@kroah.com> (Greg KH's message of "Wed,
 31
	Jan 2007 21:46:44 -0800")
Message-ID: <873b5q2c0z.fsf@javad.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> writes:

> On Wed, Jan 31, 2007 at 08:41:03PM +0300, Sergei Organov wrote:
>> Greg KH <greg@kroah.com> writes:
>> [...]
>> >> And there are plenty of documented devices that no one cares enough
>> >> about to submit a driver for.
>> >
>> > Any specific examples?  I have a long list of people who wish to write
>> > new drivers but just don't know which hardware is not yet supported.
>> 
>> Maybe not entirely a new driver, as there already exist out-of-kernel
>> vendor GPL driver, but if somebody is willing to resolve the issue
>> described here:
>> 
>> <http://article.gmane.org/gmane.linux.serial/1221>
>> 
>> please contact me, and I'll be willing to help in testing as I have the
>> hardware.
>
> Do you have a pointer to the driver source anywhere?

Sure, here it is:

<http://www.quatech.com/ManualsDriversFirmware/Communication/serial-qtpcmcia-1.23.tar.gz>

> I suggest just posting it as a patch to the tree as documented in
> Documentation/SubmittingPatches and seeing how that goes.

That won't go, I'm afraid:

1. Vendor driver doesn't compile for recent kernels. I did compile it,
   but using brute-force approach that is not appropriate for the
   kernel.

2. There is generic driver in the kernel that supports this card among
   others, should I add the ID of this particular card, but doesn't
   support baud rates higher than 115200.

3. Vendor driver is rather close to the generic one being in the kernel,
   so maybe it's better to improve generic one instead of adding yet
   another driver to the tree.

-- Sergei Organov.
