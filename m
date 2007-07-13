Return-Path: <linux-kernel-owner+w=401wt.eu-S1760955AbXGMAnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760955AbXGMAnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 20:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756323AbXGMAnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 20:43:05 -0400
Received: from twin.jikos.cz ([213.151.79.26]:48579 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756278AbXGMAnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 20:43:04 -0400
Date: Fri, 13 Jul 2007 02:42:00 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Pavel Machek <pavel@ucw.cz>
cc: Dmitry Torokhov <dtor@insightbb.com>, Andi Kleen <ak@suse.de>,
       Indan Zupancic <indan@nul.nu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       bwalle@suse.de
Subject: Re: blink driver power saving
In-Reply-To: <20070712091043.GB1866@elf.ucw.cz>
Message-ID: <Pine.LNX.4.64.0707130238230.31463@twin.jikos.cz>
References: <51563.81.207.0.53.1183376603.squirrel@secure.samage.net>
 <200707030142.36252.dtor@insightbb.com> <20070704221122.GA1719@elf.ucw.cz>
 <200707050138.49789.dtor@insightbb.com> <20070712091043.GB1866@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2007, Pavel Machek wrote:

> I'm not sure what you mean here. Should the code be moved to atkbd.c? 
> ...and then duplicated to usbkbd.c?

Hi Pavel,

just a sidenote - usbkbd.c is probably a confusing misnomer, renaming it 
to something more appropriate is on my todo for one day. It is not the 
driver that controls the USB keyboard on the majority of systems - see 
Kconfig help text, that explains it very clearly. USB keyboards are 
normally handled by usbhid module (drivers/hid/usbhid/*).

-- 
Jiri Kosina
