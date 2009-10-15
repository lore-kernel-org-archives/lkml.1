Return-Path: <linux-kernel-owner+w=401wt.eu-S1763207AbZJOWpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763207AbZJOWpb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 18:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763197AbZJOWpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 18:45:30 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:26260 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763194AbZJOWp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 18:45:29 -0400
X-Spam-Flag: NO
X-Spam-Score: -11.374
Message-ID: <4AD7A5DA.2060309@tremplin-utc.net>
Date: Fri, 16 Oct 2009 00:44:42 +0200
From: =?ISO-8859-1?Q?=C9ric_Piel?= <Eric.Piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090319 Mandriva/2.0.0.21-1mdv2009.1 (2009.1) Thunderbird/2.0.0.21 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: [REGRESSION] "bind" a device to a driver doesn't not work	anymore
References: <928C125D-D36B-47C9-A549-3EE502C9EC73@gmail.com> <4AD75AC0.6020705@tremplin-utc.net> <20091015181336.GB8544@core.coreip.homeip.net> <4AD778C7.4070707@tremplin-utc.net> <20091015195136.GD8544@core.coreip.homeip.net> <4AD7953B.5040506@tremplin-utc.net> <20091015215944.GA9845@core.coreip.homeip.net>
In-Reply-To: <20091015215944.GA9845@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 15-10-09 23:59, Dmitry Torokhov schreef:

> Hm, this is wierd... In the dmesg you sent me in the previous mail I see:
>
> input: AT Raw Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
>
> So it looks like sometimes it is in raw and sometimes it is in
> translated mode. The i8042.reset might be affecting it.
Indeed, since there is i8042.reset, it's "Raw" instead of "Translated".

> Also, are you
> using BIOS password at resume by any chance?
No, I just press the power button to resume and nothing else.

>
> I guess we'll have to wait till you get back to the box and then I want
> fresh debug dmesgs (after poweroff) of older (with bind/unbind) and latest
> kernels, going through boot, 1st (make sure to type qwerty) and 2nd
> resume (qwerty again). Make sure you don't have any other i8042 or atkbd
> switches besides i8042.debug.
Ok, I'll.

Eric
