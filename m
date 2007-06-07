Return-Path: <linux-kernel-owner+w=401wt.eu-S1765713AbXFGRvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765713AbXFGRvy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 13:51:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758338AbXFGRvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 13:51:46 -0400
Received: from smtp3.versatel.nl ([62.58.50.90]:49923 "EHLO smtp3.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756647AbXFGRvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 13:51:45 -0400
Message-ID: <466848F6.9010707@hhs.nl>
Date: Thu, 07 Jun 2007 20:05:42 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
User-Agent: Thunderbird 2.0.0.0 (X11/20070414)
MIME-Version: 1.0
To: Vojtech Pavlik <vojtech@suse.cz>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: problem with softraw and keycodes > 128
References: <4667C00D.40708@hhs.nl> <20070607131503.GA26905@suse.cz> <46681C5B.80201@hhs.nl> <20070607153639.GB5775@suse.cz>
In-Reply-To: <20070607153639.GB5775@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vojtech Pavlik wrote:
> On Thu, Jun 07, 2007 at 04:55:23PM +0200, Hans de Goede wrote:
> 
>> 2) Somehow fix things so that selecting the right model in gnome/kde
>>    keyboard-preferences will make the keys work. Like it does now with
>>    softraw=0. Which leads me to asking what are the downsides of using
>>    softraw=0?
> 
> It doesn't work with anything else but PS/2 keyboards. It's useless on
> eg. USB.
> 

This is an atkbd only setting, right, so indeed it doesn't affect USB, right?

What I'm wondering if is there is any harm to setting softraw to 0, atleast 
until there is a better fix. With it set to 0, for ps/2 keyboards all the user 
addtionally needs todo is select the correct model, for which there are nice 
gui tools.

Add a usb-keyboard (which in reality is the linuxkeyboard) model to the mix, 
for the user to select / to make default even, and things will work for usb 
users to, right?

>>    Since the xkb discriptions for most of the easy access keyboards
>>    have been written by Suse, I assume the tested them and it works
>>    for them. Does anyone know how suse does this?
> 
> I don't think it does work. One of our guys is trying to fix it by
> 
> 	1) Converting the xkb multimedia keyboard descriptions to setkeycodes descriptions
> 	2) Creating a "linux keyboard" X xkb description
> 
> Then, after loading the setkeycodes at boot for the right keyboard
> ty[e, AT keyboard will work fine, and USB and other keyboards will not
> need *any* setup to have their multimedia keys working out of the box.
> 

Thats good news, but what about gui tools to select the model, as this cannot 
be autoprobed? And what about portability of said tools to for example freebsd?

Using xkb models should work across different OS's, and is available now. All 
that is needed (for ps2 keyboards) is for the path of the special keys from the 
kernel to X-server to not change the codes.

Regards,

Hans

