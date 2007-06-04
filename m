Return-Path: <linux-kernel-owner+w=401wt.eu-S1760557AbXFDWKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760557AbXFDWKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 18:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753494AbXFDWKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 18:10:23 -0400
Received: from styx.suse.cz ([82.119.242.94]:42865 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754546AbXFDWKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 18:10:22 -0400
Date: Tue, 5 Jun 2007 00:10:42 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Renato Golin <rengolin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: joydev.c and saitek cyborg evo force
In-Reply-To: <d9b9d95f0706041506l257819a7pbcb8b8efc2eec049@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706050008160.5177@jikos.suse.cz>
References: <d9b9d95f0705180654x342ff6dbwf134243dfeabed20@mail.gmail.com> 
 <Pine.LNX.4.64.0705300207160.3961@jikos.suse.cz> 
 <d9b9d95f0705300214u7eb257fg783aefd73077d33@mail.gmail.com> 
 <Pine.LNX.4.64.0705301654560.3961@jikos.suse.cz> 
 <d9b9d95f0705300818h2eaa8130mf8a7a37966d29cc5@mail.gmail.com> 
 <d9b9d95f0705301526i66e99ef3v6c35165aa1a5f5c6@mail.gmail.com> 
 <d120d5000705311253n67d4247eh194e6f4457a0b4c@mail.gmail.com> 
 <Pine.LNX.4.64.0705312220250.5177@jikos.suse.cz> 
 <d9b9d95f0706011116j59fff917x9a86aac377f88937@mail.gmail.com> 
 <Pine.LNX.4.64.0706031139570.5177@jikos.suse.cz>
 <d9b9d95f0706041506l257819a7pbcb8b8efc2eec049@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2007, Renato Golin wrote:

> Patched and run, we're almost there... I put an additional printk on 
> usb/input/hid-core.c and hid/hid-input.c to assure I got the right copy, 
> got the messages but not the fix.

Hi Renato,

sorry, don't fully understand - what do you mean by "got the messages but 
not the fix"?

> What joydev reports is a range between 0 and 255, which is better than
> -127 to 127 because it's unsigned but still requires further
> calibration.

Well calibration using jscal might be needed, that should be fine. The 
question is whether the ranges are now correct and calibration using jscal 
works fine.

So please let me know whether the badpad quirk is the correct one for this 
joystick. If so, I'll queue it in my tree for upstream.

Thanks,

-- 
Jiri Kosina
SUSE Labs
