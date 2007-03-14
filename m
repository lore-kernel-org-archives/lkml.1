Return-Path: <linux-kernel-owner+w=401wt.eu-S932560AbXCNS6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560AbXCNS6y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 14:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932572AbXCNS6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 14:58:53 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:64442 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932560AbXCNS6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 14:58:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uKyB8Xu0piCZyadpIEboZK0tjYMrIYTpz/yToxNe+9TFaEYoqoxh3Zrj4g2jn0pOV2OC+UdfMMn+hK9c2aSo/CUTGWE7bG76uD0+VJse6TwYeRQV87PpxrHB8pjVfJ7t2/YKYbMo/pjp72jFZ1J2+9ySi22ZCeaB2HEO7tsxGDM=
Message-ID: <d120d5000703141158t4d02b8b7pc4ab967722dac@mail.gmail.com>
Date: Wed, 14 Mar 2007 14:58:49 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Vojtech Pavlik" <vojtech@suse.cz>
Subject: Re: [PATCH 0/2] wistron_btns: More keymaps
Cc: "Eric Piel" <Eric.Piel@tremplin-utc.net>, mitr@volny.cz, otauber@web.de,
       linux-kernel@vger.kernel.org,
       linux-input <linux-input@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20070314182559.GC5264@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45ECA23A.5010503@tremplin-utc.net>
	 <d120d5000703060536k7743ece9hb20fa4d1f7ad7ad7@mail.gmail.com>
	 <45ED8809.70309@tremplin-utc.net> <45F72D37.6090004@tremplin-utc.net>
	 <d120d5000703140654y4d8cb0a3oafd49c48a045bd77@mail.gmail.com>
	 <20070314182559.GC5264@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/14/07, Vojtech Pavlik <vojtech@suse.cz> wrote:
> On Wed, Mar 14, 2007 at 09:54:27AM -0400, Dmitry Torokhov wrote:
> > Hi Eric,
> >
> > On 3/13/07, Eric Piel <Eric.Piel@tremplin-utc.net> wrote:
> > >Hello,
> > >
> > >As a sequel to my patch "Wistron button support for TravelMate 610" of
> > >last week, here is a bigger addition of keymaps for the wistron_btns.
> > >
> > >Patch 1 adds all the database of acerhk which fits this driver (about 25
> > >more laptops).
> > >Patch 2 adds a generic map that should fit most users but has the
> > >disadvantage of not being automatic.
> > >
> > >Dmitry, I've tried to make them against your tree. Still, if they don't
> > >apply cleanly, just tell me and I'll try harder!
> > >
> >
> > I have couple of comments/requests:
> >
> > 1. KEY_OPEN and KEY_CLOSE should not be used to signal state of the
> > lid, they correspond to Accpication Control Open and Close keys from
> > USB HID HUT spec:
> >
> >     http://www.usb.org/developers/devclass_docs/Hut1_12.pdf
> >
> > SW_LID shoudl be used to signal lid state instead.
> >
> > 2. I also have a concern about using KEY_SCREEN to signal toggling
> > display on and off. I am CCing Vojtech - he must know what the
> > original intent of this key code was. BTW, when user presses
> > corresponding button - does the display actually goes off? Maybe we
> > need another switch.
>
> Sorry, Dmitry, I probably should have documented it back then, I don't
> have the slightest idea anymore.
>

That's what I was afraid of ;) Well, maybe we should just use it to
indicate display switch and add a comment to that effect to input.h...

-- 
Dmitry
