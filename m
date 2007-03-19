Return-Path: <linux-kernel-owner+w=401wt.eu-S1030582AbXCSV2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030582AbXCSV2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030584AbXCSV2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:28:09 -0400
Received: from wx-out-0506.google.com ([66.249.82.225]:24003 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030582AbXCSV2H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:28:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iyZfLE6qNEQoL5zD2LYna/LVYWiXmYoTHEd7i8nDP4xXV3ZbtaCQ4GEFXPoNyzANsZekmDjmZPDbc7cD8kR645WpdwrEKCi8JzcWnaYCWM1TcbB858yCBnS0edezC/NJmvJBjJjqkfcgYMYVjrARoC+y3w6LUaWoweZvuQI+uek=
Message-ID: <d120d5000703191428t11f2df22w5f28d49d2ecfcd52@mail.gmail.com>
Date: Mon, 19 Mar 2007 17:28:06 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "=?ISO-8859-1?Q?=C9ric_Piel?=" <Eric.Piel@tremplin-utc.net>
Subject: Re: [PATCH 0/2] wistron_btns: More keymaps
Cc: "Vojtech Pavlik" <vojtech@suse.cz>, mitr@volny.cz, otauber@web.de,
       linux-kernel@vger.kernel.org,
       linux-input <linux-input@atrey.karlin.mff.cuni.cz>
In-Reply-To: <45F91F73.8040200@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <45ECA23A.5010503@tremplin-utc.net>
	 <d120d5000703060536k7743ece9hb20fa4d1f7ad7ad7@mail.gmail.com>
	 <45ED8809.70309@tremplin-utc.net> <45F72D37.6090004@tremplin-utc.net>
	 <d120d5000703140654y4d8cb0a3oafd49c48a045bd77@mail.gmail.com>
	 <20070314182559.GC5264@suse.cz>
	 <d120d5000703141158t4d02b8b7pc4ab967722dac@mail.gmail.com>
	 <20070314190254.GA5843@suse.cz> <45F91F73.8040200@tremplin-utc.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/15/07, Éric Piel <Eric.Piel@tremplin-utc.net> wrote:
> 03/14/2007 08:02 PM, Vojtech Pavlik wrote/a écrit:
> > On Wed, Mar 14, 2007 at 02:58:49PM -0400, Dmitry Torokhov wrote:
> >
> >>>> 2. I also have a concern about using KEY_SCREEN to signal toggling
> >>>> display on and off. I am CCing Vojtech - he must know what the
> >>>> original intent of this key code was. BTW, when user presses
> >>>> corresponding button - does the display actually goes off? Maybe we
> >>>> need another switch.
> >>> Sorry, Dmitry, I probably should have documented it back then, I don't
> >>> have the slightest idea anymore.
> >>>
> >> That's what I was afraid of ;) Well, maybe we should just use it to
> >> indicate display switch and add a comment to that effect to input.h...
> >
> > Digging somewhat deeper into my memory, I think it just so happened that
> > there was a keyboard with a key with a pictogram of a computer screen on
> > it with no really defined purpose. Since at that time there was only a
> > limited number of different extended keyboard types, it was added.
> >
> > I think it'd make sense to use it eg. for the key that switches between
> > internal and external output on laptops, if the laptop generates a
> > keycode for the key at all. But maybe that function is already taken by
> > KEY_SWITCHVIDEOMODE ...
>
> Ok, so let me summarize:
>
> There are two kinds of keys on those laptops (for which we are not sure
> about the keycode that it should generate):
> * Laptop screen on/off
> * Display output selection (for instance: laptop/external/both)
>
> The possible keycodes that we could assign to them:
> KEY_SCREEN
> KEY_MEDIA
> KEY_MODE
> KEY_VIDEO
> KEY_SWITCHVIDEOMODE
> KEY_COMPUTER
> KEY_PC
>
>  From the discussion, I had the feeling this association would be the
> less incorrect:
> Screen on/off : KEY_SCREEN

It looks like DVB folks chose to ise KEY_SCREEN and KEY_WINDOW to
switch applications between full screen and windowed modes so we'll
have to invent our own keycode. KEY_DISPLAYTOGGLE anyone?

> Display selection : KEY_SWITCHVIDEOMODE
>

I agree here.

-- 
Dmitry
