Return-Path: <linux-kernel-owner+w=401wt.eu-S934464AbXLQCKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934464AbXLQCKT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 21:10:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760765AbXLQCKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 21:10:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33903 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755963AbXLQCKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 21:10:04 -0500
Message-ID: <4765D95C.4010404@zytor.com>
Date: Sun, 16 Dec 2007 18:05:16 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Rene Herman <rene.herman@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Paul Rolland <rol@as2917.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@ucw.cz>,
       "David P. Reed" <dpreed@reed.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
References: <4762C551.5070003@zytor.com> <20071214210652.GB28793@elf.ucw.cz> <4763001A.1070102@zytor.com> <20071214232955.545ab809@the-village.bc.nu> <20071215080831.404cdb32@tux.DEF.witbe.net> <47638C8C.2090604@gmail.com> <476438B4.2020600@zytor.com> <476462BE.3030701@gmail.com> <4764687D.6080609@zytor.com> <476524DB.7020806@gmail.com> <20071216152250.GA21245@elte.hu> <4765D43E.1010800@gmail.com>
In-Reply-To: <4765D43E.1010800@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> On 16-12-07 16:22, Ingo Molnar wrote:
> 
>> looks good to me. Could you please also provide three more controls 
>> that i suggested earlier:
>>
>>  - a boot option enabling/disabling the udelay based code
>>  - a .config method of enabling/disabling the udelay based code
>>  - a sysctl to toggle it
>>
>> if we want to clean this all up we'll need as many controls as possible.
> 
> This version does the boot and the .config option but not the sysctl. It 
> makes for clumsy code and I don't believe it provides for much added 
> value as soon as you have the boot option. I am moreover not completely 
> confident about things such as paravirt liking the possibility of the 
> native_io_delay being changed out from under them at unpredictable times.
> 

Incidentally, I had the thought earlier today that port 0xf0 might be a 
suitable delay port.  It is used only by the 387-emulating-a-287 hack 
for IRQ 13, which Linux doesn't use on 486+.

	-hpa
