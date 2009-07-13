Return-Path: <linux-kernel-owner+w=401wt.eu-S1754857AbZGMIxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbZGMIxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 04:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754799AbZGMIxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 04:53:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46238 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754731AbZGMIxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 04:53:17 -0400
Date: Mon, 13 Jul 2009 10:53:13 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Mark Lord <lkml@rtr.ca>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: Input driver for Twinhan USB 6253:0100 remote control
In-Reply-To: <20090712182026.7a09c736@neptune.home>
Message-ID: <alpine.LNX.2.00.0907131048110.10476@wotan.suse.de>
References: <20090408072935.GA27920@dtor-d630.eng.vmware.com> <200904131931.24009.dmitry.torokhov@gmail.com> <49E4B678.9030508@rtr.ca> <200904140945.14652.dmitry.torokhov@gmail.com> <49E4C9CF.5060504@rtr.ca> <alpine.LNX.2.00.0904151022170.13028@wotan.suse.de>
 <49E5EAD7.7000309@rtr.ca> <alpine.LNX.2.00.0904161123180.13028@wotan.suse.de> <20090712182026.7a09c736@neptune.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="168427776-1603017818-1247475196=:10476"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--168427776-1603017818-1247475196=:10476
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Sun, 12 Jul 2009, Bruno Prémont wrote:

> I wrote the below patch to adjust it's key mappings, though I'm not
> sure if/how I should deal with the number keys (0..9) with regard to
> keyboard layout and/or numlock key.
> 
> I tried with KEY_0..KEY_9 (default) as well as KEY_KP0..KEY_KP9 but
> neither produces optimal results on my machine (laptop with numlock
> disabled and belgian keyboard layout, e.g. KEY_1 => '&' unless shift
> is down)
> 
> KEY_NUMERIC_0..KEY_NUMERIC_9 are not recognized by Linux console (don't
> know if/how userspace understands them)

Are they incorporated in the keymap you have loaded?

> +	// set_bit(EV_REP, hi->input->evbit);

Why is this commented out?

Otherwise the patch looks good, so if you send it with proper 
Signed-off-by line, I am OK with merging it.

Do you have any idea whether lirc folks have plans to integrate support 
for this device to lirc eventually?

Thanks,

-- 
Jiri Kosina
SUSE Labs
--168427776-1603017818-1247475196=:10476--
