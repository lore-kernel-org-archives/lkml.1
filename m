Return-Path: <linux-kernel-owner+w=401wt.eu-S932704AbXCNTCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932704AbXCNTCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 15:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932705AbXCNTCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 15:02:52 -0400
Received: from wr-out-0506.google.com ([64.233.184.236]:17744 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932704AbXCNTCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 15:02:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FcygmHMoA4nrjbFpPZqXrWHQYFWMyU8DZHDRYAIghRlzjcXdLT9rQjr69yNzDpixMOA7S12VJobRc1a9MpSryoWAp9CrwrJrfk+XgKTqbt3KOOYQh8s7S1ofHTK0iuVceG48JMuBIn/DuMw+6sqQ6p1Adais7uFcVAFvH68lKdM=
Message-ID: <d120d5000703141202g3987d5beob3a0551d48003840@mail.gmail.com>
Date: Wed, 14 Mar 2007 15:02:49 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Vojtech Pavlik" <vojtech@suse.cz>
Subject: Re: [PATCH 0/2] wistron_btns: More keymaps
Cc: "Eric Piel" <Eric.Piel@tremplin-utc.net>, mitr@volny.cz, otauber@web.de,
       linux-kernel@vger.kernel.org,
       linux-input <linux-input@atrey.karlin.mff.cuni.cz>
In-Reply-To: <d120d5000703141158t4d02b8b7pc4ab967722dac@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45ECA23A.5010503@tremplin-utc.net>
	 <d120d5000703060536k7743ece9hb20fa4d1f7ad7ad7@mail.gmail.com>
	 <45ED8809.70309@tremplin-utc.net> <45F72D37.6090004@tremplin-utc.net>
	 <d120d5000703140654y4d8cb0a3oafd49c48a045bd77@mail.gmail.com>
	 <20070314182559.GC5264@suse.cz>
	 <d120d5000703141158t4d02b8b7pc4ab967722dac@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/14/07, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> On 3/14/07, Vojtech Pavlik <vojtech@suse.cz> wrote:
> > On Wed, Mar 14, 2007 at 09:54:27AM -0400, Dmitry Torokhov wrote:
> > > Hi Eric,
> > >
> > > On 3/13/07, Eric Piel <Eric.Piel@tremplin-utc.net> wrote:
> > > >Hello,
> > > >
> > > >As a sequel to my patch "Wistron button support for TravelMate 610" of
> > > >last week, here is a bigger addition of keymaps for the wistron_btns.
> > > >
> > > >Patch 1 adds all the database of acerhk which fits this driver (about 25
> > > >more laptops).
> > > >Patch 2 adds a generic map that should fit most users but has the
> > > >disadvantage of not being automatic.
> > > >
> > > >Dmitry, I've tried to make them against your tree. Still, if they don't
> > > >apply cleanly, just tell me and I'll try harder!
> > > >
> > >
> > > I have couple of comments/requests:
> > >
> > > 1. KEY_OPEN and KEY_CLOSE should not be used to signal state of the
> > > lid, they correspond to Accpication Control Open and Close keys from
> > > USB HID HUT spec:
> > >
> > >     http://www.usb.org/developers/devclass_docs/Hut1_12.pdf
> > >
> > > SW_LID shoudl be used to signal lid state instead.
> > >
> > > 2. I also have a concern about using KEY_SCREEN to signal toggling
> > > display on and off. I am CCing Vojtech - he must know what the
> > > original intent of this key code was. BTW, when user presses
> > > corresponding button - does the display actually goes off? Maybe we
> > > need another switch.
> >
> > Sorry, Dmitry, I probably should have documented it back then, I don't
> > have the slightest idea anymore.
> >
>
> That's what I was afraid of ;) Well, maybe we should just use it to
> indicate display switch and add a comment to that effect to input.h...
>

Oh, wait, DVB uses this code to request switchin full screen mode, we
better not touch it.

-- 
Dmitry
