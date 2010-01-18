Return-Path: <linux-kernel-owner+w=401wt.eu-S1752912Ab0ARHEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab0ARHEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 02:04:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297Ab0ARHEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 02:04:22 -0500
Received: from smtp1.entryit.no ([212.4.42.179]:54444 "EHLO smtp1.entryit.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033Ab0ARHEV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 02:04:21 -0500
From: Eirik Aanonsen <EAA@wprmedical.com>
To: Greg KH <greg@kroah.com>
CC: "kernel@avr32linux.org" <kernel@avr32linux.org>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 18 Jan 2010 08:02:46 +0100
Subject: RE: [PATCH 1/1] atmel uaba : Adding invert vbus_pin
Thread-Topic: [PATCH 1/1] atmel uaba : Adding invert vbus_pin
Thread-Index: AcqWH6zJRDa33iglSlGtoTA8RB7kVAB6/6nw
Message-ID: <B5E0EDE940845B429B7ECCE186529F2C0641D181F7@dware2702>
References: <B5E0EDE940845B429B7ECCE186529F2C0641D177FD@dware2702>
 <20100115185457.GG12146@kroah.com>
In-Reply-To: <20100115185457.GG12146@kroah.com>
Accept-Language: nb-NO
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: nb-NO
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> On Mon, Jan 04, 2010 at 02:01:59PM +0100, Eirik Aanonsen wrote:
> > Adding vbus_pin_inverted so that the usb detect pin can be active
> high or low.
> > This because depending on HW implementation it is better to have
> active low.
> > Also replaced the pio_get_value(udc->vbus_pin); with a call to
> vbus_is_present(udc);
> >
> > Signed-off-by: Eirik Aanonsen <eaa@wprmedical.com>
> 
> Please always run your patches through 'scripts/checkpatch.pl' before
> sending them so that you don't accidentally add coding style errors.
> 
> thanks,
> 
> greg k-h

Yes I'm sorry I got that feedback from several others as well.

That is why I resubmitted the patch on 05.Jan. But under the same name, and since then I have not received any feedback on that patch.

***
Snip from local:

./scripts/checkpatch.pl 0014-Adding-vbus_pin_inverted-so-that-the-usb-detect-pin.patch 
total: 0 errors, 0 warnings, 38 lines checked

0014-Adding-vbus_pin_inverted-so-that-the-usb-detect-pin.patch has no obvious style problems and is ready for submission.
***

Best regards
____________________________________________________
 
Eirik Aanonsen
SW Developer
E-mail: eaa@wprmedical.com 
Phone: +47 90 68 11 92
Fax: +47 37 03 56 77
____________________________________________________



