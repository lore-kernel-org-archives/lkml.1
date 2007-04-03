Return-Path: <linux-kernel-owner+w=401wt.eu-S965393AbXDCBmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965393AbXDCBmE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 21:42:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966141AbXDCBmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 21:42:04 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:12568 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965393AbXDCBmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 21:42:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Z1DetSWKpk0sZld6gK7zbNms7V+orH3BRgLn8J5NCfx/tgLiT2K/iMqrJHQxX/4wc4918en3pnZbUKJIewNREOaeJNP1u6fvkvFHjk5YE5N1/mcBGLlIhYnYthwA0fVMWCJSzd2HtjaxNi8VboORIkNBMj1cE7BZ5kIgG3Wd06g=
Message-ID: <4611B0A1.8070106@gmail.com>
Date: Tue, 03 Apr 2007 09:40:49 +0800
From: Li Yu <raise.sail@gmail.com>
User-Agent: Thunderbird 1.5 (X11/20051201)
MIME-Version: 1.0
To: Nicolas Mailhot <nicolas.mailhot@laposte.net>
CC: Li Yu <raise.sail@gmail.com>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net, Jiri Kosina <jkosina@suse.cz>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [linux-usb-devel] [RFC] HID bus design overview.
References: <56464.192.54.193.51.1175515024.squirrel@rousalka.dyndns.org>
In-Reply-To: <56464.192.54.193.51.1175515024.squirrel@rousalka.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Mailhot wrote:
>> Er, I also want to know what are drawbacks of "flip-flopping" ?
>>     
>
> This will cause major havoc as soon as hot-plugging and apps listening to
> HAL events (xorg eventually) enter in play.
>
>   

~_~

It really need some extra works in user space, but I do not think this
is so critical. These HAL events should not be frequently, and happen
when system boot early very likely. In fact, these works also exist with
blacklist means, but it migrate to HID driver developer, and from
runtime move to development-time. (Of course, you can do it by sysfs,
just like vmware, I think it is so).

Although I do not agree very much, since such many guru said the
"flip-flopping" is not good idea, It is likely appropriate, I also will
change code later,  this make the implementation more easier in fact.

May be, we need some means to change blacklist in runtime. and
loading/unloading such driver by specific script to do it.

