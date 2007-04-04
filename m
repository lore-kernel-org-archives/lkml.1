Return-Path: <linux-kernel-owner+w=401wt.eu-S1752609AbXDDXCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbXDDXCf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 19:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbXDDXCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 19:02:35 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:54653 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbXDDXCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 19:02:33 -0400
Message-ID: <02f801c7770d$3eafb050$84163e05@kroptech.com>
From: "Adam Kropelin" <akropel1@rochester.rr.com>
To: "Jiri Kosina" <jkosina@suse.cz>, "Li Yu" <raise.sail@gmail.com>
Cc: <yanghong@ccoss.com.cn>,
       "linux-usb-devel" <linux-usb-devel@lists.sourceforge.net>,
       <hongzhiyi@ccoss.com.cn>, "Marcel Holtmann" <marcel@holtmann.org>,
       "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       "LKML" <linux-kernel@vger.kernel.org>
References: <200703051532096508636@gmail.com> <45FE6971.6090503@gmail.com> <1174897676.5815.6.camel@violet> <4609CAF2.3040303@ccoss.com.cn> <Pine.LNX.4.64.0703280945560.19566@jikos.suse.cz> <d120d5000703281200wd914f51s18437a6a8e4107f6@mail.gmail.com> <1175516515.5815.347.camel@violet> <Pine.LNX.4.64.0704021429420.3808@jikos.suse.cz> <1175532439.5815.375.camel@violet> <4611AAC1.8050303@gmail.com> <Pine.LNX.4.64.0704031053140.3808@jikos.suse.cz>
Subject: Re: [linux-usb-devel] [RFC] HID bus design overview.
Date: Wed, 4 Apr 2007 19:01:57 -0400
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
> On Tue, 3 Apr 2007, Li Yu wrote:
>
>> What's the position of hidraw? It only is used when all other driver
>> is not usable on some report? or, it should be stick every working
>> device.
>
> Current implementation (as you can see it in -mm or in my hid.git
> tree) is creating hidraw interface for just every HID
> device/interface. But this will get changed before merge.
>
> Passing just everything to hidraw is not a good option, as this could
> lead to confusion and duplicating of input events (i.e. in-kernel hid
> driver processes the report and generates input_event(), and also
> userland driver obtains data from hidraw and generates input event
> through uinput ... not good).

I apologize for picking up this thread late and asking what may be a 
question with an obvious answer...

Will hiddev still exist after hidraw and the HID bus redesign work is 
done? I have a widely-deployed userspace app that relies on hiddev, and 
I'm looking for reassurance that it will still work as it always has...

--Adam

