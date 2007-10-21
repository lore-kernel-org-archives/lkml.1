Return-Path: <linux-kernel-owner+w=401wt.eu-S1752346AbXJUL6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346AbXJUL6Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 07:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbXJUL6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 07:58:17 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:8127 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbXJUL6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 07:58:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=e6F2ZOSPJiQwp3Dpt4TPKvKDEGSdyn7CEOD2JLfyHER7D/Wu0gQQaJiJrx3bplkhQaDRaoCDTjBrTIKgVxpa2TEqWd8lv+rZdq174RJA/NzXgdQRTUwuWb3DHdbxYt/vKyM5b2HmhydEPNpkG58AeCggh7KoAkQe9TqP/bknWvI=
Message-ID: <efe7343f0710210458haf18bf2u145402d0de8cf62d@mail.gmail.com>
Date: Sun, 21 Oct 2007 12:58:15 +0100
From: "Luis Correia" <luis.f.correia@gmail.com>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: Re: [Rt2400-devel] rt73usb: support for wireless in Kohjinsha subnotebook
Cc: "Pavel Machek" <pavel@ucw.cz>, rt2400-devel@lists.sourceforge.net,
       "kernel list" <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org, mwallis@serialmonkey.com
In-Reply-To: <200710211609.27675.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071020184100.GA11640@elf.ucw.cz>
	 <200710211549.44955.IvDoorn@gmail.com>
	 <20071021113815.GF25270@elf.ucw.cz>
	 <200710211609.27675.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On 10/21/07, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> On Sunday 21 October 2007, Pavel Machek wrote:
> > On Sun 2007-10-21 15:49:44, Ivo van Doorn wrote:
> > > On Sunday 21 October 2007, Pavel Machek wrote:
> > > > Hi!
> > > >
> > > > > > Kohjinsha subnotebook seems to contain wifi with USB IDs 0x18e8,
> > > > > > 0x6206... I hope that to be compatible with
> > > > > > net/wireless/rt2x00/rt73usb.c .
> > > > >
> > > > > Is there any reason you assume it is a rt73usb device,
> > > > > or are you just making wild guesses about what the chipset is?
> > > >
> > > > Wild guess. I've seen 18e8:6XXX being handled by rt73usb, so..
> > >
> > > Thats an incorrect assumption. USB ID's listed in rt73usb don't even
> > > guarentee that the device contains a rt73usb chipset since some manufacturers
> > > produce cards with different chipsets while keeping the USB ID the same.
> > > So the case that the card false in the 6xxx range says absolutely _nothing_.
> >
> > Well, see the other mail, it seems like rt73usb partially communicates
> > with the card.
>
> If you add a USB ID to the driver, then you are telling it to communciate to
> the device. It doesn't suddenly make the driver compatible with the device.
>
> > What info would be useful in determining what is this card similar to?
> > Boot windows and look for driver name?
>
> Looking at the name of the windows driver is indeed usually a good start,
> but you don't need to boot to windows to check that. How about looking
> at the driver name on the driver CD, or on the support website of the
> manufacturer.

I'm currently going throught the manufacturer's website (in Japanese)
to try and figure out which wireless chipset it is.

Only one driver to go and I'm not even sure it is the wireless driver...

Luis Correia
