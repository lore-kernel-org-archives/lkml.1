Return-Path: <linux-kernel-owner+w=401wt.eu-S947977AbXHMPGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S947977AbXHMPGj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 11:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030657AbXHMMpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 08:45:30 -0400
Received: from opal.biophys.uni-duesseldorf.de ([134.99.176.7]:35768 "EHLO
	opal.biophys.uni-duesseldorf.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030562AbXHMMp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 08:45:26 -0400
X-Greylist: delayed 492 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Aug 2007 08:45:25 EDT
Date: Mon, 13 Aug 2007 14:36:55 +0200 (CEST)
From: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@atrey.karlin.mff.cuni.cz, linuxppc-dev@ozlabs.org,
       debian-68k@lists.debian.org
Subject: Re: [patch 10/10] m68k/mac: Make mac_hid_mouse_emulate_buttons()
 declaration visible
In-Reply-To: <20070812094119.910815432@mail.of.borg>
Message-ID: <Pine.LNX.4.58.0708131432560.32732@om.biophys.uni-duesseldorf.de>
References: <20070812094050.522858761@mail.of.borg> <20070812094119.910815432@mail.of.borg>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Geert Uytterhoeven <geert@linux-m68k.org>
>
> m68k/mac: Make mac_hid_mouse_emulate_buttons() declaration visible

With buttons emulation being available via uinput event devices, do we
still need the kernel mouse button emulation? At least on powerpc, it was
declared deprecated long ago ...

Anyone using mouseemu on m68k Mac?

	Michael
