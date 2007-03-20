Return-Path: <linux-kernel-owner+w=401wt.eu-S1030774AbXCTAHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030774AbXCTAHT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 20:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030776AbXCTAHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 20:07:18 -0400
Received: from smtp2-g19.free.fr ([212.27.42.28]:47101 "EHLO smtp2-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030774AbXCTAHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 20:07:17 -0400
X-Greylist: delayed 96980 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Mar 2007 20:07:16 EDT
Message-ID: <45FF258B.5090007@tremplin-utc.net>
Date: Tue, 20 Mar 2007 01:06:35 +0100
From: =?ISO-8859-1?Q?=C9ric_Piel?= <Eric.Piel@tremplin-utc.net>
User-Agent: Thunderbird 2.0b2 (X11/20070307)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Vojtech Pavlik <vojtech@suse.cz>, mitr@volny.cz, otauber@web.de,
       linux-kernel@vger.kernel.org,
       linux-input <linux-input@atrey.karlin.mff.cuni.cz>
Subject: Re: [PATCH 0/2] wistron_btns: More keymaps
References: <45ECA23A.5010503@tremplin-utc.net>	 <d120d5000703060536k7743ece9hb20fa4d1f7ad7ad7@mail.gmail.com>	 <45ED8809.70309@tremplin-utc.net> <45F72D37.6090004@tremplin-utc.net>	 <d120d5000703140654y4d8cb0a3oafd49c48a045bd77@mail.gmail.com>	 <20070314182559.GC5264@suse.cz>	 <d120d5000703141158t4d02b8b7pc4ab967722dac@mail.gmail.com>	 <20070314190254.GA5843@suse.cz> <45F91F73.8040200@tremplin-utc.net> <d120d5000703191428t11f2df22w5f28d49d2ecfcd52@mail.gmail.com>
In-Reply-To: <d120d5000703191428t11f2df22w5f28d49d2ecfcd52@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

19.03.2007 22:28, Dmitry Torokhov wrote/a écrit:
> On 3/15/07, Éric Piel <Eric.Piel@tremplin-utc.net> wrote:
>>
>> Ok, so let me summarize:
>>
>> There are two kinds of keys on those laptops (for which we are not sure
>> about the keycode that it should generate):
>> * Laptop screen on/off
>> * Display output selection (for instance: laptop/external/both)
>>
>> The possible keycodes that we could assign to them:
>> KEY_SCREEN
>> KEY_MEDIA
>> KEY_MODE
>> KEY_VIDEO
>> KEY_SWITCHVIDEOMODE
>> KEY_COMPUTER
>> KEY_PC
>>
>>  From the discussion, I had the feeling this association would be the
>> less incorrect:
>> Screen on/off : KEY_SCREEN
> 
> It looks like DVB folks chose to ise KEY_SCREEN and KEY_WINDOW to
> switch applications between full screen and windowed modes
Just for info, I couldn't find any reference to KEY_WINDOW. Anyway, 
indeed, KEY_SCREEN is already used for "full screen" (although sometimes 
it's KEY_ZOOM :-/) so better not using it if something else is possible.

> so we'll
> have to invent our own keycode. KEY_DISPLAYTOGGLE anyone?
What about KEY_DISPLAYONOFF ? :-)
What should be its value? Would 239 be fine?

>> Display selection : KEY_SWITCHVIDEOMODE
> I agree here. 

BTW, I'm thinking of implementing led support. However, there are two 
mechanisms for leds in the kernel: the "input layer" leds and the "full 
feature" leds. The laptops may have up to three leds: mail, wifi, 
bluetooth. The input layer has LED_MAIL but no wifi nor bluetooth. The 
led subsystem has the advantage of the very extensible "trigger" 
mechanism. Which of the subsystems would you recommend me to use?

See you,
Eric
