Return-Path: <linux-kernel-owner+w=401wt.eu-S1754900Ab0AMNVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab0AMNVn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 08:21:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754299Ab0AMNVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 08:21:42 -0500
Received: from smtp1.entryit.no ([212.4.42.179]:50170 "EHLO smtp1.entryit.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753849Ab0AMNVl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 08:21:41 -0500
From: Eirik Aanonsen <EAA@wprmedical.com>
To: Eirik Aanonsen <EAA@wprmedical.com>,
       "kernel@avr32linux.org" <kernel@avr32linux.org>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 13 Jan 2010 14:20:40 +0100
Subject: RE: [PATCH 1/1] atmel uaba : Adding invert vbus_pin
Thread-Topic: [PATCH 1/1] atmel uaba : Adding invert vbus_pin
Thread-Index: AcqN48dOrjX+1T2DTKONu97r3uR6wQGbqWNg
Message-ID: <B5E0EDE940845B429B7ECCE186529F2C0641D17F76@dware2702>
References: <B5E0EDE940845B429B7ECCE186529F2C0641D17873@dware2702>
In-Reply-To: <B5E0EDE940845B429B7ECCE186529F2C0641D17873@dware2702>
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

> Subject: [PATCH 1/1] atmel uaba : Adding invert vbus_pin
> 
> Thanks to Ben Nizette [bn@niasdigital.com] and Sergei Shtylyov
> [sshtylyov@ru.mvista.com] for good feedback
> 
> Adding vbus_pin_inverted so that the usb detect pin can be active high
> or low.
> This because depending on HW implementation it is better to have active
> low.
> Also replaced the pio_get_value(udc->vbus_pin); with a call to
> vbus_is_present(udc);
> 
> Signed-off-by: Eirik Aanonsen <eaa@wprmedical.com>
> ---

...

No one that have any comments on this? 

Haavard is it possible to get this upstream?

The patch allows the USB driver to be active and when the USB bus is disconnected (with reversed signaling).
I observe a drop in power consumption of 150mW, and for people dependent on battery that is a lot.
And in our design we need to have this pin inverted.

Regards
____________________________________________________
 
Eirik Aanonsen
SW Developer
E-mail: eaa@wprmedical.com 
Phone: +47 90 68 11 92
Fax: +47 37 03 56 77
____________________________________________________


