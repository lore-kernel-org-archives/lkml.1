Return-Path: <linux-kernel-owner+w=401wt.eu-S1755565AbXEaVso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbXEaVso (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 17:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751537AbXEaVsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 17:48:37 -0400
Received: from twin.jikos.cz ([213.151.79.26]:39083 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbXEaVsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 17:48:37 -0400
Date: Thu, 31 May 2007 23:48:33 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Renato Golin <rengolin@gmail.com>
cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: joydev.c and saitek cyborg evo force
In-Reply-To: <Pine.LNX.4.64.0705312220250.5177@jikos.suse.cz>
Message-ID: <Pine.LNX.4.64.0705312343400.29896@twin.jikos.cz>
References: <d9b9d95f0705180654x342ff6dbwf134243dfeabed20@mail.gmail.com> 
 <200705210016.20794.dtor@insightbb.com>  <Pine.LNX.4.64.0705211444500.22906@jikos.suse.cz>
  <d9b9d95f0705291657o47ef42d3jea2a1dae3e31bbdb@mail.gmail.com> 
 <Pine.LNX.4.64.0705300207160.3961@jikos.suse.cz> 
 <d9b9d95f0705300214u7eb257fg783aefd73077d33@mail.gmail.com> 
 <Pine.LNX.4.64.0705301654560.3961@jikos.suse.cz> 
 <d9b9d95f0705300818h2eaa8130mf8a7a37966d29cc5@mail.gmail.com> 
 <d9b9d95f0705301526i66e99ef3v6c35165aa1a5f5c6@mail.gmail.com>
 <d120d5000705311253n67d4247eh194e6f4457a0b4c@mail.gmail.com>
 <Pine.LNX.4.64.0705312220250.5177@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2007, Jiri Kosina wrote:

> Yes, the problem with axis ranges definitely looks like that. Renato, 
> could you please send me vendor id and product id of the joystick in 
> question, I will send you a patch to test whether normalizing the values 
> on hid-level (as we already do for several other joypads) will do the 
> trick?

... or if you are running reasonably recent kernel (2.6.22-rc1 or newer), 
you can add the quirk in runtime without need to recompile, just pass the 
parameter in the format

	quirks=0xAAAA:0xBBBB:0x20

to usbhid module, where 0xAAAA is vendor ID and 0xBBBB product ID of your 
joystick.

Thanks,

-- 
Jiri Kosina
SUSE Labs

