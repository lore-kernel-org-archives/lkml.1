Return-Path: <linux-kernel-owner+w=401wt.eu-S1752695AbXJULb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbXJULb3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 07:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbXJULbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 07:31:21 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:59545 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbXJULbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 07:31:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=UZpD8TLkiblckcpqRIFBsQ3eXV/4S8/jI6R2+7uqS+ZQ0qrWEfPg8pL6usPYNagTKZ+PGkaTSy6i45Tb9vNP9eNhoWiHK3rhtsF8tyeHu3RsqP5a9+Regfv1ITRPDrfdeMR9UwhtZn6inmHO4vWKcUmQTYev74nR0wqnRh1sk/M=
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [Rt2400-devel] rt73usb: support for wireless in Kohjinsha subnotebook
Date: Sun, 21 Oct 2007 15:49:44 +0200
User-Agent: KMail/1.9.7
Cc: rt2400-devel@lists.sourceforge.net,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org, mwallis@serialmonkey.com
References: <20071020184100.GA11640@elf.ucw.cz> <200710210012.37547.IvDoorn@gmail.com> <20071021092138.GC25270@elf.ucw.cz>
In-Reply-To: <20071021092138.GC25270@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710211549.44955.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 21 October 2007, Pavel Machek wrote:
> Hi!
> 
> > > Kohjinsha subnotebook seems to contain wifi with USB IDs 0x18e8,
> > > 0x6206... I hope that to be compatible with
> > > net/wireless/rt2x00/rt73usb.c .
> > 
> > Is there any reason you assume it is a rt73usb device,
> > or are you just making wild guesses about what the chipset is?
> 
> Wild guess. I've seen 18e8:6XXX being handled by rt73usb, so..

Thats an incorrect assumption. USB ID's listed in rt73usb don't even
guarentee that the device contains a rt73usb chipset since some manufacturers
produce cards with different chipsets while keeping the USB ID the same.
So the case that the card false in the 6xxx range says absolutely _nothing_.

Ivo
