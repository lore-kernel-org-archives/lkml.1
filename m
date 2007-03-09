Return-Path: <linux-kernel-owner+w=401wt.eu-S1767326AbXCIOlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767326AbXCIOlQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 09:41:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767328AbXCIOlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 09:41:16 -0500
Received: from twin.jikos.cz ([213.151.79.26]:46029 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767326AbXCIOlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 09:41:15 -0500
Date: Fri, 9 Mar 2007 15:40:49 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Richard Purdie <rpurdie@rpsys.net>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: Keyboard stops working after *lock [Was: 2.6.21-rc2-mm1]
In-Reply-To: <d120d5000703090613v2923e9c1k8389b566257daa43@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0703091531280.26904@twin.jikos.cz>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org> 
 <45E996A0.6070700@gmail.com> <45E99A45.9030506@gmail.com> 
 <20070303094125.838ce04d.akpm@linux-foundation.org>  <45F13791.8040408@gmail.com>
 <d120d5000703090613v2923e9c1k8389b566257daa43@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Mar 2007, Dmitry Torokhov wrote:

> > > > > (II) evdev brain: Rescanning devices (12).
> > > > > (II) evdev brain: Rescanning devices (13).
> > > > > (II) evdev brain: Rescanning devices (14).
> > > > > in this kernel, but I don't know if this is relevant.
> > > > > After booting back to .20-mm2 everything is OK.
> > > Thanks.  Cc's added.
> > Remains unsolved in 2.6.21-rc3-mm2.
> Does a PS/2 keyboard behave for you?
> Nowadays I forward all USB HID related issues to Jiri Kosina ;) (CCed).

Hi,

more importantly, does 2.6.21-rc3 work for you? There are not that many 
USB HID/hidinput specific patches in -mm, so it would show clearly whether 
it's problem in USB HID/hidinput, or somewhere else.

What keyboard is that please? (vedor/product ids)

Also, if it turns out to be HID problem - could you please send output of 
both working and non-working kernels with hid/usbhid debugging enabled?

If this is present also in vanilla and not only in -mm, could you please 
try reverting commits 4237081e573b99a48991aa71364b0682c444651c and 
d4ae650a904612ffb7edd3f28b69b022988d2466 and let me know if the situation 
gets any better?

Thanks,

-- 
Jiri Kosina
