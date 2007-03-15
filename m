Return-Path: <linux-kernel-owner+w=401wt.eu-S1752804AbXCOK1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbXCOK1H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 06:27:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbXCOK1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 06:27:07 -0400
Received: from vulpecula.futurs.inria.fr ([195.83.212.5]:37235 "EHLO
	vulpecula.futurs.inria.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbXCOK1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 06:27:05 -0400
Message-ID: <45F91F73.8040200@tremplin-utc.net>
Date: Thu, 15 Mar 2007 11:26:59 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <Eric.Piel@tremplin-utc.net>
User-Agent: Thunderbird 2.0b2 (X11/20070307)
MIME-Version: 1.0
To: Vojtech Pavlik <vojtech@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, mitr@volny.cz, otauber@web.de,
       linux-kernel@vger.kernel.org,
       linux-input <linux-input@atrey.karlin.mff.cuni.cz>
Subject: Re: [PATCH 0/2] wistron_btns: More keymaps
References: <45ECA23A.5010503@tremplin-utc.net> <d120d5000703060536k7743ece9hb20fa4d1f7ad7ad7@mail.gmail.com> <45ED8809.70309@tremplin-utc.net> <45F72D37.6090004@tremplin-utc.net> <d120d5000703140654y4d8cb0a3oafd49c48a045bd77@mail.gmail.com> <20070314182559.GC5264@suse.cz> <d120d5000703141158t4d02b8b7pc4ab967722dac@mail.gmail.com> <20070314190254.GA5843@suse.cz>
In-Reply-To: <20070314190254.GA5843@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

03/14/2007 08:02 PM, Vojtech Pavlik wrote/a écrit:
> On Wed, Mar 14, 2007 at 02:58:49PM -0400, Dmitry Torokhov wrote:
> 
>>>> 2. I also have a concern about using KEY_SCREEN to signal toggling
>>>> display on and off. I am CCing Vojtech - he must know what the
>>>> original intent of this key code was. BTW, when user presses
>>>> corresponding button - does the display actually goes off? Maybe we
>>>> need another switch.
>>> Sorry, Dmitry, I probably should have documented it back then, I don't
>>> have the slightest idea anymore.
>>>
>> That's what I was afraid of ;) Well, maybe we should just use it to
>> indicate display switch and add a comment to that effect to input.h...
> 
> Digging somewhat deeper into my memory, I think it just so happened that
> there was a keyboard with a key with a pictogram of a computer screen on
> it with no really defined purpose. Since at that time there was only a
> limited number of different extended keyboard types, it was added.
> 
> I think it'd make sense to use it eg. for the key that switches between
> internal and external output on laptops, if the laptop generates a
> keycode for the key at all. But maybe that function is already taken by
> KEY_SWITCHVIDEOMODE ...

Ok, so let me summarize:

There are two kinds of keys on those laptops (for which we are not sure 
about the keycode that it should generate):
* Laptop screen on/off
* Display output selection (for instance: laptop/external/both)

The possible keycodes that we could assign to them:
KEY_SCREEN
KEY_MEDIA
KEY_MODE
KEY_VIDEO
KEY_SWITCHVIDEOMODE
KEY_COMPUTER
KEY_PC

 From the discussion, I had the feeling this association would be the 
less incorrect:
Screen on/off : KEY_SCREEN
Display selection : KEY_SWITCHVIDEOMODE

Is that ok with everyone? If not, please suggest something better ;-)

See you,
Eric

PS: So far, I believe that for all laptops, those keys are just normal 
keys (as opposed to a key which would also do by itself its intended 
action).  At least on a 3020, pressing "screen on/off" doesn't 
automatically switch on/off the screen.



