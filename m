Return-Path: <linux-kernel-owner+w=401wt.eu-S1759901AbXEUMqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759901AbXEUMqx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 08:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758261AbXEUMqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 08:46:42 -0400
Received: from styx.suse.cz ([82.119.242.94]:47857 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758219AbXEUMql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 08:46:41 -0400
Date: Mon, 21 May 2007 14:49:40 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Renato Golin <rengolin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dtor@insightbb.com>
Subject: Re: joydev.c and saitek cyborg evo force
In-Reply-To: <200705210016.20794.dtor@insightbb.com>
Message-ID: <Pine.LNX.4.64.0705211444500.22906@jikos.suse.cz>
References: <d9b9d95f0705180654x342ff6dbwf134243dfeabed20@mail.gmail.com>
 <200705210016.20794.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2007, Dmitry Torokhov wrote:

> > I have a Saitek Cyborg Evo Force, a very good joystick with force- 
> > feedback. Problem is, on Windows it works well (its drivers know its 
> > own idiosyncrasies) but on Linux it gets a bit fuzzy.
> I think we need to make HID driver to report real range for Saitek. 
> Jiri, any ideas?

Renato,

could you please turn on the HID debugging support ("Device Drivers -> HID 
devices -> HID debugging support" in menuconfig of any reasonably recent 
kernel) and show the output that appears when the joystick is plugged in, 
and also when you generate the events that are messed up? This would 
hopefully avoid any confusion regarding what is really going on and we'll 
see what we can do with it.

Thanks,

-- 
Jiri Kosina
SUSE Labs
