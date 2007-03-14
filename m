Return-Path: <linux-kernel-owner+w=401wt.eu-S932346AbXCNS0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346AbXCNS0d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 14:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932446AbXCNS0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 14:26:33 -0400
Received: from styx.suse.cz ([82.119.242.94]:58731 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932346AbXCNS0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 14:26:32 -0400
Date: Wed, 14 Mar 2007 19:25:59 +0100
From: Vojtech Pavlik <vojtech@suse.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Eric Piel <Eric.Piel@tremplin-utc.net>, mitr@volny.cz, otauber@web.de,
       linux-kernel@vger.kernel.org,
       linux-input <linux-input@atrey.karlin.mff.cuni.cz>
Subject: Re: [PATCH 0/2] wistron_btns: More keymaps
Message-ID: <20070314182559.GC5264@suse.cz>
References: <45ECA23A.5010503@tremplin-utc.net> <d120d5000703060536k7743ece9hb20fa4d1f7ad7ad7@mail.gmail.com> <45ED8809.70309@tremplin-utc.net> <45F72D37.6090004@tremplin-utc.net> <d120d5000703140654y4d8cb0a3oafd49c48a045bd77@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d120d5000703140654y4d8cb0a3oafd49c48a045bd77@mail.gmail.com>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2007 at 09:54:27AM -0400, Dmitry Torokhov wrote:
> Hi Eric,
> 
> On 3/13/07, Eric Piel <Eric.Piel@tremplin-utc.net> wrote:
> >Hello,
> >
> >As a sequel to my patch "Wistron button support for TravelMate 610" of
> >last week, here is a bigger addition of keymaps for the wistron_btns.
> >
> >Patch 1 adds all the database of acerhk which fits this driver (about 25
> >more laptops).
> >Patch 2 adds a generic map that should fit most users but has the
> >disadvantage of not being automatic.
> >
> >Dmitry, I've tried to make them against your tree. Still, if they don't
> >apply cleanly, just tell me and I'll try harder!
> >
> 
> I have couple of comments/requests:
> 
> 1. KEY_OPEN and KEY_CLOSE should not be used to signal state of the
> lid, they correspond to Accpication Control Open and Close keys from
> USB HID HUT spec:
> 
>     http://www.usb.org/developers/devclass_docs/Hut1_12.pdf
> 
> SW_LID shoudl be used to signal lid state instead.
> 
> 2. I also have a concern about using KEY_SCREEN to signal toggling
> display on and off. I am CCing Vojtech - he must know what the
> original intent of this key code was. BTW, when user presses
> corresponding button - does the display actually goes off? Maybe we
> need another switch.

Sorry, Dmitry, I probably should have documented it back then, I don't
have the slightest idea anymore.

> 3. The number of keymap tables grew considerably ;) Do you think it
> woudl make sense to allocate memory for keymap at device creation time
> and copy selected keymap and them mark all original keymaps as
> __initdata so they are discarded one module completed initialization?
> 
> Thank you.

-- 
Vojtech Pavlik
Director SuSE Labs
