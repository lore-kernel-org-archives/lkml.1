Return-Path: <linux-kernel-owner+w=401wt.eu-S1761622AbXEaUSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761622AbXEaUSL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 16:18:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756420AbXEaUR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 16:17:58 -0400
Received: from styx.suse.cz ([82.119.242.94]:56784 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756472AbXEaUR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 16:17:57 -0400
Date: Thu, 31 May 2007 22:22:12 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Renato Golin <rengolin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: joydev.c and saitek cyborg evo force
In-Reply-To: <d120d5000705311253n67d4247eh194e6f4457a0b4c@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705312220250.5177@jikos.suse.cz>
References: <d9b9d95f0705180654x342ff6dbwf134243dfeabed20@mail.gmail.com> 
 <200705210016.20794.dtor@insightbb.com>  <Pine.LNX.4.64.0705211444500.22906@jikos.suse.cz>
  <d9b9d95f0705291657o47ef42d3jea2a1dae3e31bbdb@mail.gmail.com> 
 <Pine.LNX.4.64.0705300207160.3961@jikos.suse.cz> 
 <d9b9d95f0705300214u7eb257fg783aefd73077d33@mail.gmail.com> 
 <Pine.LNX.4.64.0705301654560.3961@jikos.suse.cz> 
 <d9b9d95f0705300818h2eaa8130mf8a7a37966d29cc5@mail.gmail.com> 
 <d9b9d95f0705301526i66e99ef3v6c35165aa1a5f5c6@mail.gmail.com>
 <d120d5000705311253n67d4247eh194e6f4457a0b4c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2007, Dmitry Torokhov wrote:

> > Now, why joydev's input_dev is reporting -127, 127 just for the two 
> > first axis?
> Is it getting hit with HID_QUIRK_BADPAD? What does evtest utility show
> for the device?

Yes, the problem with axis ranges definitely looks like that. Renato, 
could you please send me vendor id and product id of the joystick in 
question, I will send you a patch to test whether normalizing the values 
on hid-level (as we already do for several other joypads) will do the 
trick?

I have currently no idea about the incorrect number of buttons, will look 
at it a little bit more.

Thanks,

-- 
Jiri Kosina
SUSE Labs
