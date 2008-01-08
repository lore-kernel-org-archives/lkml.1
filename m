Return-Path: <linux-kernel-owner+w=401wt.eu-S1755777AbYAHSy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777AbYAHSy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 13:54:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbYAHSyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 13:54:49 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:52512 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195AbYAHSys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 13:54:48 -0500
Date: Tue, 8 Jan 2008 19:51:41 +0100 (CET)
From: Bodo Eggert <7eggert@gmx.de>
To: Ondrej Zary <linux@rainbow-software.org>
cc: "David P. Reed" <dpreed@reed.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Rene Herman <rene.herman@keyaccess.nl>, Bodo Eggert <7eggert@gmx.de>,
       Christer Weinigel <christer@weinigel.se>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Paul Rolland <rol@as2917.net>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [linux-kernel] Re: [PATCH] x86: provide a DMI based port 0x80
 I/O delay override.
In-Reply-To: <200801081838.16241.linux@rainbow-software.org>
Message-ID: <alpine.LSU.0.999.0801081950470.3158@be1.lrz>
References: <9BdU5-1YW-9@gated-at.bofh.it> <200801081810.58904.linux@rainbow-software.org>
 <4783B1B2.6070005@reed.com>
 <200801081838.16241.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1/aPUs8csnKSXfDPu2qtHFsU/bEO4v9Hdo2y9U
 mYhylVBPHlGmdikaaUVgFUnAipC15gi5f7r6RAXuLxpuvvUcsw
 7NlvSgPcFfod4OQRP6cRQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jan 2008, Ondrej Zary wrote:
> On Tuesday 08 January 2008 18:24:02 David P. Reed wrote:

> > Windows these days does delays with timing loops or the scheduler.  It
> > doesn't use a "port".  Also, Windows XP only supports machines that tend
> > not to have timing problems that use delays.  Instead, if a device takes
> > a while to respond, it has a "busy bit" in some port or memory slot that
> > can be tested.
> 
> Windows XP can run on a machine with ISA slot(s) and has built-in drivers for 
> some plug&play ISA cards - e.g. the famous 3Com EtherLink III. I think that 
> there's a driver for NE2000-compatible cards too and it probably works.

The NE2K-driver went missing in W2K. BTDT.
-- 
Anyone can speak Troll. All you have to do is point and grunt.
	-- Fred Weasley
