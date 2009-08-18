Return-Path: <linux-kernel-owner+w=401wt.eu-S1759533AbZHRRqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759533AbZHRRqM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 13:46:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759493AbZHRRqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 13:46:10 -0400
Received: from mail.cs.nmsu.edu ([128.123.64.3]:41826 "EHLO mail.cs.nmsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759423AbZHRRqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 13:46:09 -0400
Message-ID: <ea371b5c9240c10ec5543c7963c0d274.squirrel@intranet.cs.nmsu.edu>
In-Reply-To: <20090818160215.GB7039@kroah.com>
References: <9f97a27ccc13bd63ce99be04018b6bde.squirrel@intranet.cs.nmsu.edu>
    <20090818151427.GA6295@kroah.com>
    <ead4b2f9b7e5b1a415d010c524812e3a.squirrel@intranet.cs.nmsu.edu>
    <20090818160215.GB7039@kroah.com>
Date: Tue, 18 Aug 2009 11:46:10 -0600
Subject: Re: Purpose of parameter in sysfs binary read
From: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
To: "Greg KH" <greg@kroah.com>
Cc: "Linux USB" <linux-usb@vger.kernel.org>,
       "LKML" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Tue, Aug 18, 2009 at 09:41:56AM -0600, Rick L. Vinyard, Jr. wrote:
>> Greg KH wrote:
>> > On Tue, Aug 18, 2009 at 08:55:29AM -0600, Rick L. Vinyard, Jr. wrote:
>> > What are you using the binary sysfs attribute for?  It should ONLY be
>> > used as a pass-through to and from hardware, with no interpretation by
>> > the kernel at all.
>>
>> It's for the Logitech G13's game panel image (a simple binary bitmap of
>> the pixels).
>>
>> It doesn't do any interpretation... just a few checks on the magic
>> number
>> and size.
>
> Cool.  Have a pointer to the driver yet?
>

Not quite ready yet. Still trying to figure out how to handle the input
buttons in the hid framework.

There is another driver out there, but they went outside the hid driver
and established an interrupt urb and I'm still familiarizing myself with
how the hid driver handles interrupts so I can get the keypresses.

Everything else (backlight control and loading game panel images) seems to
be working though.



