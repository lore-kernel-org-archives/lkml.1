Return-Path: <linux-kernel-owner+w=401wt.eu-S1753250Ab0AHO1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab0AHO1F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 09:27:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368Ab0AHO1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 09:27:04 -0500
Received: from fornax3.pixelized.ch ([188.40.97.208]:53411 "EHLO
	fornax3.0.iobloggo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab0AHO1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 09:27:01 -0500
X-Greylist: delayed 334 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Jan 2010 09:27:01 EST
Message-ID: <4B473F64.2010203@debian.org>
Date: Fri, 08 Jan 2010 15:21:24 +0100
From: "Giacomo A. Catenazzi" <cate@debian.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
CC: Jaya Kumar <jayakumar.lkml@gmail.com>, linux-kernel@vger.kernel.org,
       krzysztof.h1@wp.pl, akpm@linux-foundation.org,
       linux-usb@vger.kernel.org, oliver@neukum.org,
       linux-input@vger.kernel.org, jkosina@suse.cz,
       linux-fbdev@vger.kernel.org
Subject: Re: [PATCH] Logitech G13 driver (fixed cc list --- ignore others)
References: <200912142122.nBELMW7d001243@mustang.cs.nmsu.edu>    <45a44e481001041557t1f87f8d4i959abbbee0c4346@mail.gmail.com> <635ab1237a6a988656a2bf28e488f656.squirrel@intranet.cs.nmsu.edu>
In-Reply-To: <635ab1237a6a988656a2bf28e488f656.squirrel@intranet.cs.nmsu.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry to enter in this discussion so late.

What about g15 keyboards and related keyboards?

It would nice if your driver could handle also the other keyboards.

The package g15daemon handles such keyboards (or LCD screens):

# Logitech g11 -- extra keys, no LCD
# Logitech G15 (blue) -- extra keys and LCD
# Logitech G15 v2 (orange) -- extra keys and LCD
# Logitech Z10 -- extra keys and LCD, shared with audio, not a keyboard
# Logitech G15 Gamepanel -- extra keys and LCD

but using an daemon has it own problems, so I would like to
move the support to the kernel.

Is it ok for you?

Could you use a more generic name for configuration?
(e.g. CONFIG_LOGITECH_G_SERIES)

ciao
	cate


On 07.01.2010 16:59, Rick L. Vinyard, Jr. wrote:
> Jaya Kumar wrote:
>> On Tue, Dec 15, 2009 at 5:22 AM, Rick L. Vinyard Jr.
>> <rvinyard@cs.nmsu.edu>  wrote:
>>> Additionally, this device contains a 160x43 monochrome LCD display.
>>> A registered framebuffer device manages this display. The design
>>> of this portion of the driver was based on the design of the
>>> hecubafb driver with deferred framebuffer I/O since there is
>>> no real memory to map.
>>
>> Hi Rick,
>>
>> Interesting work. I recommend CCing linux-fbdev@vger.kernel.org too
>> since it contains a fbdev interface.
>>
>
> Thanks. Added.
>
>>> +config LOGITECH_G13
>>> +       tristate "Logitech G13 gameboard support"
>>> +       depends on HID_LOGITECH
>>> +       depends on FB
>>> +       select FB_SYS_FILLRECT
>>> +       select FB_SYS_COPYAREA
>>> +       select FB_SYS_IMAGEBLIT
>>> +       select FB_SYS_FOPS
