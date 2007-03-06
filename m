Return-Path: <linux-kernel-owner+w=401wt.eu-S1030603AbXCFN0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030603AbXCFN0F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 08:26:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030608AbXCFN0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 08:26:05 -0500
Received: from ik-out-1112.google.com ([66.249.90.183]:1583 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030603AbXCFN0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 08:26:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=q6TWTGIApTt3TVV7oOba2xYBNUGk67oPX2HXquMk3XjuhgVn1ZNZTuJwdvJaKa0RKJtURiofKfReq2tLQa4WQ2ChzieE06Nzm+6Zm6J5aKPRRFOOxDh3std6MgqPeksDyEhuSBtyOqwwFXdmdisXZnNVQf8MDfOU6lnpwTMOyRY=
Message-ID: <d120d5000703060525x26da3274r5cc4ac724e1f0beb@mail.gmail.com>
Date: Tue, 6 Mar 2007 08:25:59 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Marcel Holtmann" <marcel@holtmann.org>
Subject: Re: [DOC] The documentation for HID Simple Driver Interface 0.5.0
Cc: "Li Yu" <raise.sail@gmail.com>, "Greg Kroah Hartman" <greg@kroah.com>,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       "Vincent Legoll" <vincentlegoll@gmail.com>,
       "Zephaniah E. Hull" <warp@aehallh.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Harold Sargeant" <harold-sargeant@ntlworld.com>,
       liyu <liyu@ccoss.com.cn>
In-Reply-To: <1173134421.6638.117.camel@aeonflux.holtmann.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703051532096508636@gmail.com>
	 <1173127471.6638.96.camel@aeonflux.holtmann.net>
	 <d120d5000703051211xb44adcckadd706560caa86e2@mail.gmail.com>
	 <1173134421.6638.117.camel@aeonflux.holtmann.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcel,

On 3/5/07, Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi Dmitry,
>
> > > This also means that the current keyboard and mouse
> > > input devices will become a HID driver.
> >
> > Are you talking about usbmouse and usbkbd?
>
> no, because if I recall correctly these are the boot mode drivers and
> actually not used at all in any modern distribution.
>
> For me the task of converting HID reports into input events shouldn't be
> actually the job of the HID core layer. My understanding is that the HID
> core should support multiple transport layers. This is currently
> achieved through the hid_device abstraction and used by the USB and by
> the Bluetooth subsystem. This is the lower interface to HID. On the
> upper interface I like to see a driver like interface. So we can
> register specific drivers that can handle specific use cases or vendor
> specific reports. For standard keyboard and mouse reports we however
> should have a standard driver that can handle most of them.
>
> For identification we actually do have the bus type, vendor id and
> product id available. We also can register drivers for specific report
> ids or usages.
>
> I do like the HID simple driver idea, but it is not a simple driver, it
> should be a generic driver interface.
>

Ah, OK. Then we are in complete agreement ;)

-- 
Dmitry
