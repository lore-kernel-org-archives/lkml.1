Return-Path: <linux-kernel-owner+w=401wt.eu-S935002AbXLQCVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935002AbXLQCVW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 21:21:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756838AbXLQCVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 21:21:14 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:31004 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbXLQCVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 21:21:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=dLksclDyY4ksxbmS9MnFWJAVHuJh8J5uv/sZfu+HcEzcNIE10oqDGlLZn+KUufmR5NzwsOSs+Ul1kNHzXogqYcQq6UvR7spWwjIUkzXMYLPiA9dRtzmlxsa4S+AvH/p7Yqomkrgw+9eCqsCehVgmrX4qzko5hjaR5MLDeoj8MdU=
Message-ID: <4765DCB0.8030901@gmail.com>
Date: Mon, 17 Dec 2007 03:19:28 +0100
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Paul Rolland <rol@as2917.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@ucw.cz>,
       "David P. Reed" <dpreed@reed.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
References: <4762C551.5070003@zytor.com> <20071214210652.GB28793@elf.ucw.cz> <4763001A.1070102@zytor.com> <20071214232955.545ab809@the-village.bc.nu> <20071215080831.404cdb32@tux.DEF.witbe.net> <47638C8C.2090604@gmail.com> <476438B4.2020600@zytor.com> <476462BE.3030701@gmail.com> <4764687D.6080609@zytor.com> <476524DB.7020806@gmail.com> <20071216152250.GA21245@elte.hu> <4765D43E.1010800@gmail.com> <4765D95C.4010404@zytor.com>
In-Reply-To: <4765D95C.4010404@zytor.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17-12-07 03:05, H. Peter Anvin wrote:

> Incidentally, I had the thought earlier today that port 0xf0 might be a 
> suitable delay port.  It is used only by the 387-emulating-a-287 hack 
> for IRQ 13, which Linux doesn't use on 486+.

rene@7ixe4:~/src/port80$ su -c ./port80
cycles: out 2400, in 2400
rene@7ixe4:~/src/port80$ su -c ./portf0
cycles: out 2400, in 2400

(Duron 1300)

I suppose you mean using it instead of port 0x80 always and not just as an 
alternate port? For the latter 0xed is alright I guess...


Rene.
