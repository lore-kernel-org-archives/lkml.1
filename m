Return-Path: <linux-kernel-owner+w=401wt.eu-S932805AbXCNTMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805AbXCNTMN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 15:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932844AbXCNTMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 15:12:13 -0400
Received: from vulpecula.futurs.inria.fr ([195.83.212.5]:36831 "EHLO
	vulpecula.futurs.inria.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932833AbXCNTMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 15:12:12 -0400
Message-ID: <45F8490A.6000807@tremplin-utc.net>
Date: Wed, 14 Mar 2007 20:12:10 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <Eric.Piel@tremplin-utc.net>
User-Agent: Thunderbird 2.0b2 (X11/20070307)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Vojtech Pavlik <vojtech@suse.cz>, mitr@volny.cz, otauber@web.de,
       linux-kernel@vger.kernel.org,
       linux-input <linux-input@atrey.karlin.mff.cuni.cz>
Subject: Re: [PATCH 0/2] wistron_btns: More keymaps
References: <45ECA23A.5010503@tremplin-utc.net>	 <d120d5000703060536k7743ece9hb20fa4d1f7ad7ad7@mail.gmail.com>	 <45ED8809.70309@tremplin-utc.net> <45F72D37.6090004@tremplin-utc.net>	 <d120d5000703140654y4d8cb0a3oafd49c48a045bd77@mail.gmail.com>	 <20070314182559.GC5264@suse.cz>	 <d120d5000703141158t4d02b8b7pc4ab967722dac@mail.gmail.com> <d120d5000703141202g3987d5beob3a0551d48003840@mail.gmail.com>
In-Reply-To: <d120d5000703141202g3987d5beob3a0551d48003840@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

03/14/2007 08:02 PM, Dmitry Torokhov wrote/a écrit:
> On 3/14/07, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
>> On 3/14/07, Vojtech Pavlik <vojtech@suse.cz> wrote:
>> > On Wed, Mar 14, 2007 at 09:54:27AM -0400, Dmitry Torokhov wrote:
>> > > Hi Eric,
>> > >
>> > > 2. I also have a concern about using KEY_SCREEN to signal toggling
>> > > display on and off. I am CCing Vojtech - he must know what the
>> > > original intent of this key code was. BTW, when user presses
>> > > corresponding button - does the display actually goes off? Maybe we
>> > > need another switch.
>> >
>> > Sorry, Dmitry, I probably should have documented it back then, I don't
>> > have the slightest idea anymore.
>> >
>>
>> That's what I was afraid of ;) Well, maybe we should just use it to
>> indicate display switch and add a comment to that effect to input.h...
>>
> 
> Oh, wait, DVB uses this code to request switchin full screen mode, we
> better not touch it.
> 
Isn't that what is supposed to do KEY_SWITCHVIDEOMODE? Humm... I've got 
a feeling that it's not clear where the documentation is or that 
documentation is missing ;-)

IIRC, about a month ago someone already asked for precision on the 
meaning of some KEY_* . It would probably worth documenting more each 
key. More specifically, it could be interesting to decide if the keycode 
has to be associated to the physical symbol displayed on the key or 
associated to the function that the user (developer) expects when 
pressing this key.

Eric
