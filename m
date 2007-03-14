Return-Path: <linux-kernel-owner+w=401wt.eu-S932705AbXCNTD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932705AbXCNTD3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 15:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932716AbXCNTD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 15:03:29 -0400
Received: from styx.suse.cz ([82.119.242.94]:59374 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932705AbXCNTD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 15:03:28 -0400
Date: Wed, 14 Mar 2007 20:02:54 +0100
From: Vojtech Pavlik <vojtech@suse.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Eric Piel <Eric.Piel@tremplin-utc.net>, mitr@volny.cz, otauber@web.de,
       linux-kernel@vger.kernel.org,
       linux-input <linux-input@atrey.karlin.mff.cuni.cz>
Subject: Re: [PATCH 0/2] wistron_btns: More keymaps
Message-ID: <20070314190254.GA5843@suse.cz>
References: <45ECA23A.5010503@tremplin-utc.net> <d120d5000703060536k7743ece9hb20fa4d1f7ad7ad7@mail.gmail.com> <45ED8809.70309@tremplin-utc.net> <45F72D37.6090004@tremplin-utc.net> <d120d5000703140654y4d8cb0a3oafd49c48a045bd77@mail.gmail.com> <20070314182559.GC5264@suse.cz> <d120d5000703141158t4d02b8b7pc4ab967722dac@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d120d5000703141158t4d02b8b7pc4ab967722dac@mail.gmail.com>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2007 at 02:58:49PM -0400, Dmitry Torokhov wrote:

> >> I have couple of comments/requests:
> >>
> >> 1. KEY_OPEN and KEY_CLOSE should not be used to signal state of the
> >> lid, they correspond to Accpication Control Open and Close keys from
> >> USB HID HUT spec:
> >>
> >>     http://www.usb.org/developers/devclass_docs/Hut1_12.pdf
> >>
> >> SW_LID shoudl be used to signal lid state instead.
> >>
> >> 2. I also have a concern about using KEY_SCREEN to signal toggling
> >> display on and off. I am CCing Vojtech - he must know what the
> >> original intent of this key code was. BTW, when user presses
> >> corresponding button - does the display actually goes off? Maybe we
> >> need another switch.
> >
> >Sorry, Dmitry, I probably should have documented it back then, I don't
> >have the slightest idea anymore.
> >
> 
> That's what I was afraid of ;) Well, maybe we should just use it to
> indicate display switch and add a comment to that effect to input.h...

Digging somewhat deeper into my memory, I think it just so happened that
there was a keyboard with a key with a pictogram of a computer screen on
it with no really defined purpose. Since at that time there was only a
limited number of different extended keyboard types, it was added.

I think it'd make sense to use it eg. for the key that switches between
internal and external output on laptops, if the laptop generates a
keycode for the key at all. But maybe that function is already taken by
KEY_SWITCHVIDEOMODE ...

-- 
Vojtech Pavlik
Director SuSE Labs
