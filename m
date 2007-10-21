Return-Path: <linux-kernel-owner+w=401wt.eu-S1751980AbXJULvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980AbXJULvT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 07:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbXJULvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 07:51:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:14333 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbXJULvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 07:51:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=XbCliOGL3Px2SEx+li3SPWpdAWZnAd/+EIb2m8THqQk3DVMSlUGltj5q5EnNYk7vLmJdW4WMXYBS3j7BXnd0luxtQLS3XKgSnXCHqJRTQmWkQvrpU0YGYlQ9U6visJNL72Gy5/cQzTVvoGaTGX9/KZxDU5UMckYGWIQ5D9WiPcI=
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [Rt2400-devel] rt73usb: support for wireless in Kohjinsha subnotebook
Date: Sun, 21 Oct 2007 16:09:27 +0200
User-Agent: KMail/1.9.7
Cc: rt2400-devel@lists.sourceforge.net,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org, mwallis@serialmonkey.com
References: <20071020184100.GA11640@elf.ucw.cz> <200710211549.44955.IvDoorn@gmail.com> <20071021113815.GF25270@elf.ucw.cz>
In-Reply-To: <20071021113815.GF25270@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710211609.27675.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 21 October 2007, Pavel Machek wrote:
> On Sun 2007-10-21 15:49:44, Ivo van Doorn wrote:
> > On Sunday 21 October 2007, Pavel Machek wrote:
> > > Hi!
> > > 
> > > > > Kohjinsha subnotebook seems to contain wifi with USB IDs 0x18e8,
> > > > > 0x6206... I hope that to be compatible with
> > > > > net/wireless/rt2x00/rt73usb.c .
> > > > 
> > > > Is there any reason you assume it is a rt73usb device,
> > > > or are you just making wild guesses about what the chipset is?
> > > 
> > > Wild guess. I've seen 18e8:6XXX being handled by rt73usb, so..
> > 
> > Thats an incorrect assumption. USB ID's listed in rt73usb don't even
> > guarentee that the device contains a rt73usb chipset since some manufacturers
> > produce cards with different chipsets while keeping the USB ID the same.
> > So the case that the card false in the 6xxx range says absolutely _nothing_.
> 
> Well, see the other mail, it seems like rt73usb partially communicates
> with the card.

If you add a USB ID to the driver, then you are telling it to communciate to
the device. It doesn't suddenly make the driver compatible with the device.

> What info would be useful in determining what is this card similar to?
> Boot windows and look for driver name?

Looking at the name of the windows driver is indeed usually a good start,
but you don't need to boot to windows to check that. How about looking
at the driver name on the driver CD, or on the support website of the
manufacturer.

Ivo
