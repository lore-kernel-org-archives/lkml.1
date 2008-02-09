Return-Path: <linux-kernel-owner+w=401wt.eu-S1757354AbYBIV5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354AbYBIV5J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 16:57:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754555AbYBIV44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 16:56:56 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:47705 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925AbYBIV4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 16:56:54 -0500
Date: Sat, 9 Feb 2008 22:56:52 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
cc: Greg KH <greg@kroah.com>, Patrick Ringl <patrick_@freenet.de>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-storage@vger.kernel.org
Subject: Re: wrong cylinders of kingston usb pendrive [intel 82801DB]
In-Reply-To: <20080204081508.GB14573@one-eyed-alien.net>
Message-ID: <Pine.LNX.4.64.0802092256300.6917@fbirervta.pbzchgretzou.qr>
References: <47A6615D.9090201@freenet.de> <20080204015937.GA16989@kroah.com>
 <20080204081508.GB14573@one-eyed-alien.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 4 2008 00:15, Matthew Dharm wrote:
>> On Mon, Feb 04, 2008 at 01:50:37AM +0100, Patrick Ringl wrote:
>> > Hello,
>> >
>> > I am suffering from the following (usb-related?) problem:
>> >
>> > I have several different mashines - all x86 architecture - just lets call 
>> > them mashineA, mashineB and mashineC.
>> 
>> Is the kernel the same on all of these machines?
>
>I'm not sure it matters...
>
>usb-storage has no knowledge of CHS geometery.  It deals entirely in LBA.
>
>Does anyone know where the kernel gets the CHS geometery equivalent from?

Something like `hdparm -I` I suppose.

