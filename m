Return-Path: <linux-kernel-owner+w=401wt.eu-S1752814AbZHSS07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbZHSS07 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 14:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbZHSS06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 14:26:58 -0400
Received: from mail.cs.nmsu.edu ([128.123.64.3]:46958 "EHLO mail.cs.nmsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515AbZHSS05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 14:26:57 -0400
Message-ID: <4effccadf47be8ed42ec057bfc84d586.squirrel@intranet.cs.nmsu.edu>
In-Reply-To: <20090819181102.GA12609@kroah.com>
References: <9f97a27ccc13bd63ce99be04018b6bde.squirrel@intranet.cs.nmsu.edu>
    <20090818151427.GA6295@kroah.com>
    <ead4b2f9b7e5b1a415d010c524812e3a.squirrel@intranet.cs.nmsu.edu>
    <20090819170501.1dbd29a8@lxorguk.ukuu.org.uk>
    <5ea7c6a46fa1e051d69a302fdc8961ac.squirrel@intranet.cs.nmsu.edu>
    <20090819181102.GA12609@kroah.com>
Date: Wed, 19 Aug 2009 12:26:52 -0600
Subject: Re: Purpose of parameter in sysfs binary read
From: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
To: "Greg KH" <greg@kroah.com>
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Linux USB" <linux-usb@vger.kernel.org>,
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
> On Wed, Aug 19, 2009 at 11:41:28AM -0600, Rick L. Vinyard, Jr. wrote:
>> Alan Cox wrote:
>> > On Tue, 18 Aug 2009 09:41:56 -0600
>> > "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu> wrote:
>> >
>> >> Greg KH wrote:
>> >> > On Tue, Aug 18, 2009 at 08:55:29AM -0600, Rick L. Vinyard, Jr.
>> wrote:
>> >> > What are you using the binary sysfs attribute for?  It should ONLY
>> be
>> >> > used as a pass-through to and from hardware, with no interpretation
>> by
>> >> > the kernel at all.
>> >>
>> >> It's for the Logitech G13's game panel image (a simple binary bitmap
>> of
>> >> the pixels).
>> >>
>> >> It doesn't do any interpretation... just a few checks on the magic
>> >> number
>> >> and size.
>> >
>> > If its a bitmap image why not register the device as a framebuffer ?
>> >
>>
>> Would that preclude it also being registered as a HID? The primary
>> purpose
>> of the device is to function as a keypad input.
>
> Is the framebuffer a different USB interface?  Or are they all
> controlled through the same one?
>

Same USB interface. That's why I was thinking it might not work out. In
fact, it uses the same interrupt pipe as the HID reports.

