Return-Path: <linux-kernel-owner+w=401wt.eu-S1752826AbXDDXfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbXDDXfA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 19:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbXDDXfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 19:35:00 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:45618 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbXDDXe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 19:34:59 -0400
Message-ID: <036401c77711$cee286d0$84163e05@kroptech.com>
From: "Adam Kropelin" <akropel1@rochester.rr.com>
To: "Jiri Kosina" <jkosina@suse.cz>
Cc: "Li Yu" <raise.sail@gmail.com>, <yanghong@ccoss.com.cn>,
       "linux-usb-devel" <linux-usb-devel@lists.sourceforge.net>,
       <hongzhiyi@ccoss.com.cn>, "Marcel Holtmann" <marcel@holtmann.org>,
       "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       "LKML" <linux-kernel@vger.kernel.org>
References: <200703051532096508636@gmail.com> <45FE6971.6090503@gmail.com> <1174897676.5815.6.camel@violet> <4609CAF2.3040303@ccoss.com.cn> <Pine.LNX.4.64.0703280945560.19566@jikos.suse.cz> <d120d5000703281200wd914f51s18437a6a8e4107f6@mail.gmail.com> <1175516515.5815.347.camel@violet> <Pine.LNX.4.64.0704021429420.3808@jikos.suse.cz> <1175532439.5815.375.camel@violet> <4611AAC1.8050303@gmail.com> <Pine.LNX.4.64.0704031053140.3808@jikos.suse.cz> <02f801c7770d$3eafb050$84163e05@kroptech.com> <Pine.LNX.4.64.0704050109500.4173@jikos.suse.cz>
Subject: Re: [linux-usb-devel] [RFC] HID bus design overview.
Date: Wed, 4 Apr 2007 19:34:37 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3028
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Wed, 4 Apr 2007, Adam Kropelin wrote:
>
>> I apologize for picking up this thread late and asking what may be a
>> question with an obvious answer... Will hiddev still exist after
>> hidraw and the HID bus redesign work is done? I have a
>> widely-deployed userspace app that relies on hiddev, and I'm looking
>> for reassurance that it will still work as it always has...
>
> Hi Adam,
>
> hiddev will have to stay for quite some time, exactly because of
> backward compatibility with userspace applications/drivers that use
> it (I am not aware of many of them though, but apparently there are
> some).

Apcupsd is the one on my mind, but I believe there are others.

> I won't allow it to vanish, don't worry.

Thanks!

> We just have to make sure that new users will use hidraw instead, as
> it provides more flexibility for the user, is not dependent on the
> underlying transport protocol, etc.

On Apcupsd we've recently introduced a libusb-based driver that does all 
HID parsing in userspace. Not only does that free us from hiddev, it 
also frees us from the umpteen other proprietary HID interfaces across 
various platforms. Although the hiddev-based driver is still the default 
for Linux platforms, I plan to change that in the next major release and 
thus begin migrating folks off of hiddev.

I appreciate your pledge to keep hiddev functioning in the mean time :)

--Adam

