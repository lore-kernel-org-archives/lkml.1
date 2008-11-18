Return-Path: <linux-kernel-owner+w=401wt.eu-S1753029AbYKRJiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029AbYKRJiO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 04:38:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751875AbYKRJh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 04:37:56 -0500
Received: from styx.suse.cz ([82.119.242.94]:51133 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751827AbYKRJhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 04:37:54 -0500
Date: Tue, 18 Nov 2008 10:37:53 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Valdis.Kletnieks@vt.edu
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, Dmitry Torokhov <dtor@mail.ru>
Subject: Re: 2.6.28-rc4-mmotm1110 shift-lock oddness
In-Reply-To: <18584.1226975771@turing-police.cc.vt.edu>
Message-ID: <alpine.LNX.1.10.0811181035020.19853@jikos.suse.cz>
References: <5397.1226959015@turing-police.cc.vt.edu> <20081117162350.82b2806b.akpm@linux-foundation.org>            <alpine.LRH.1.10.0811180125150.3104@twin.jikos.cz> <18584.1226975771@turing-police.cc.vt.edu>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2008, Valdis.Kletnieks@vt.edu wrote:

> > First, we'd need a little bit more information about the hardware in 
> > question, I guess.
> Dell Latitude D820 laptop, with a USB-connected Microsoft Natural 
> keyboard. I don't think it's the USB subsystem going *completely* 
> bonkers, as the USB-connected trackball mouse functions just fine when 
> this happens...

Does this happen only when Microsoft natural keyboard is connected, or 
does it happen also when you use the built-in keyboard?

What vendor/product ID does the USB keyboard have, please?

> > What laptop is that, please? Is the keyboard PS/2-connected or 
> > USB-connected? Could you obtain evtest output from the buggy cases please?
> Hmm.. Got a pointer to a usable copy? 

All decent distros ship this, usually as part of input-utils package.

> The best I could find googling for
> 'linux evtest' was:


> https://svn.openwrt.org/openwrt/packages/utils/event_test/src/evtest.c
> which wants a /dev/inputN - all I have is /dev/input/ and entries under that
> for the laptop's onboard mousepad and the trackball mouse, no keyboard entry.

Yes, /dev/input/eventN is used these days (when CONFIG_INPUT_EVDEV is 
turned on).

-- 
Jiri Kosina
SUSE Labs
