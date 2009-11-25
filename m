Return-Path: <linux-kernel-owner+w=401wt.eu-S1759198AbZKYTTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759198AbZKYTTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 14:19:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759119AbZKYTTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 14:19:24 -0500
Received: from mail.cs.nmsu.edu ([128.123.64.3]:60157 "EHLO mail.cs.nmsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759022AbZKYTTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 14:19:23 -0500
X-Greylist: delayed 841 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Nov 2009 14:19:23 EST
Message-ID: <c53e47c966cc5f6c7b3616f9be83ad23.squirrel@intranet.cs.nmsu.edu>
In-Reply-To: <20090819193457.538aad95@lxorguk.ukuu.org.uk>
References: <9f97a27ccc13bd63ce99be04018b6bde.squirrel@intranet.cs.nmsu.edu>
    <20090818151427.GA6295@kroah.com>
    <ead4b2f9b7e5b1a415d010c524812e3a.squirrel@intranet.cs.nmsu.edu>
    <20090819170501.1dbd29a8@lxorguk.ukuu.org.uk>
    <5ea7c6a46fa1e051d69a302fdc8961ac.squirrel@intranet.cs.nmsu.edu>
    <20090819191944.23e6e0ee@lxorguk.ukuu.org.uk>
    <3eb87686d834e14f35378d3c3c79fb02.squirrel@intranet.cs.nmsu.edu>
    <20090819193457.538aad95@lxorguk.ukuu.org.uk>
Date: Wed, 25 Nov 2009 12:19:21 -0700
Subject: Re: Purpose of parameter in sysfs binary read
From: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: "Greg KH" <greg@kroah.com>, "Linux USB" <linux-usb@vger.kernel.org>,
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

Alan Cox wrote:
>> 160x43 --- The same as the G15 and MX5000 keyboards. In fact, it takes
>> the
>> same bitmap pattern as the keyboards.
>>
>> 160x43 is small, but some graphics are definitely possible, console/text
>> is certainly possible.
>
> Ultimately it should probably also create a console device of itself, but
> its not something trivial to do and I really wouldn't bother about it
> until it works in current form if ever...
>
> Mind you a keyboard that has the display built in would be really useful
> for poking around server boxes on racks.
>

I have the display as a framebuffer device now (based on fbdefio with the
hid device as the parent).

Do I really need a separate console device or can I just use fbcon?


