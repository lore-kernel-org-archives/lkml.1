Return-Path: <linux-kernel-owner+w=401wt.eu-S1753232AbXE3AG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbXE3AG6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 20:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750999AbXE3AGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 20:06:51 -0400
Received: from styx.suse.cz ([82.119.242.94]:57417 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750904AbXE3AGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 20:06:50 -0400
Date: Wed, 30 May 2007 02:10:53 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Renato Golin <rengolin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dtor@insightbb.com>
Subject: Re: joydev.c and saitek cyborg evo force
In-Reply-To: <d9b9d95f0705291657o47ef42d3jea2a1dae3e31bbdb@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705300207160.3961@jikos.suse.cz>
References: <d9b9d95f0705180654x342ff6dbwf134243dfeabed20@mail.gmail.com> 
 <200705210016.20794.dtor@insightbb.com>  <Pine.LNX.4.64.0705211444500.22906@jikos.suse.cz>
 <d9b9d95f0705291657o47ef42d3jea2a1dae3e31bbdb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007, Renato Golin wrote:

> The HID sources are quite different from 2.6.21 and 2.6.20 but I don't 
> know how much was because Canonical guys and how much it really changed. 
> :( I will eventually put a Gentoo on my old laptop and try it for real, 
> sorry I couldn't be of much help now...

Hi Renato,

well I have changed the overall HID code design in 2.6.21 a little bit. 
Anyway, just hardcoding '#define DEBUG' and '#define DEBUG_DATA' (that's 
also important) in 2.6.20-and-older kernels should have similar result as 
CONFIG_HID_DEBUG in post-2.6.21.

In your particular case, the DEBUG_DATA might really be more interesting.

Thanks,

-- 
Jiri Kosina
SUSE Labs
