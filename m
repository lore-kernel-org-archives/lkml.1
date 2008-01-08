Return-Path: <linux-kernel-owner+w=401wt.eu-S1756823AbYAHRjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823AbYAHRjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 12:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756793AbYAHRi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 12:38:57 -0500
Received: from ns.gsystems.sk ([62.176.172.50]:50901 "EHLO www.gsystems.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756725AbYAHRiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 12:38:55 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: "David P. Reed" <dpreed@reed.com>
Subject: Re: [linux-kernel] Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
Date: Tue, 8 Jan 2008 18:38:11 +0100
User-Agent: KMail/1.9.7
Cc: "H. Peter Anvin" <hpa@zytor.com>, Rene Herman <rene.herman@keyaccess.nl>,
       Bodo Eggert <7eggert@gmx.de>, Christer Weinigel <christer@weinigel.se>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
References: <9BdU5-1YW-9@gated-at.bofh.it> <200801081810.58904.linux@rainbow-software.org> <4783B1B2.6070005@reed.com>
In-Reply-To: <4783B1B2.6070005@reed.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801081838.16241.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 January 2008 18:24:02 David P. Reed wrote:
> Windows these days does delays with timing loops or the scheduler.  It
> doesn't use a "port".  Also, Windows XP only supports machines that tend
> not to have timing problems that use delays.  Instead, if a device takes
> a while to respond, it has a "busy bit" in some port or memory slot that
> can be tested.

Windows XP can run on a machine with ISA slot(s) and has built-in drivers for 
some plug&play ISA cards - e.g. the famous 3Com EtherLink III. I think that 
there's a driver for NE2000-compatible cards too and it probably works.

> Almost all of the issues in Linux where _p operations are used are (or
> should be) historical - IMO.
>
> Ondrej Zary wrote:
> > On Tuesday 08 January 2008 02:38:15 David P. Reed wrote:
> >> H. Peter Anvin wrote:
> >>> And shoot the designer of this particular microcontroller firmware.
> >>
> >> Well, some days I want to shoot the "designer" of the entire Wintel
> >> architecture...  it's not exactly "designed" by anybody of course, and
> >> today it's created largely by a collection of Taiwanese and Chinese ODM
> >> firms, coupled with Microsoft WinHEC and Intel folks.  At least they
> >> follow the rules and their ACPI and BIOS code say that they are using
> >> port 80 very clearly if you use PnP and ACPI properly.  And in the old
> >> days, you were "supposed" to use the system BIOS to talk to things like
> >> the PIT that had timing issues, not write your own code.
> >
> > Does anyone know what port does Windows use? I'm pretty sure that it
> > isn't 80h as I run Windows 98 often with port 80h debug card inserted.
> > The last POST code set by BIOS usually remains on the display and only
> > changes when BIOS does something like suspend/resume. IIRC, there was a
> > program that was able to display temperature from onboard sensors on the
> > port 80h display that's integrated on some mainboards.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Ondrej Zary
