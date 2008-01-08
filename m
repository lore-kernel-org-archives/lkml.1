Return-Path: <linux-kernel-owner+w=401wt.eu-S1762938AbYAHRMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762938AbYAHRMu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 12:12:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755343AbYAHRMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 12:12:41 -0500
Received: from ns.gsystems.sk ([62.176.172.50]:50806 "EHLO www.gsystems.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864AbYAHRMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 12:12:41 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: "David P. Reed" <dpreed@reed.com>
Subject: Re: [linux-kernel] Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
Date: Tue, 8 Jan 2008 18:10:53 +0100
User-Agent: KMail/1.9.7
Cc: "H. Peter Anvin" <hpa@zytor.com>, Rene Herman <rene.herman@keyaccess.nl>,
       Bodo Eggert <7eggert@gmx.de>, Christer Weinigel <christer@weinigel.se>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
References: <9BdU5-1YW-9@gated-at.bofh.it> <4782C017.3000208@zytor.com> <4782D407.7010301@reed.com>
In-Reply-To: <4782D407.7010301@reed.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801081810.58904.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 January 2008 02:38:15 David P. Reed wrote:
> H. Peter Anvin wrote:
> > And shoot the designer of this particular microcontroller firmware.
>
> Well, some days I want to shoot the "designer" of the entire Wintel
> architecture...  it's not exactly "designed" by anybody of course, and
> today it's created largely by a collection of Taiwanese and Chinese ODM
> firms, coupled with Microsoft WinHEC and Intel folks.  At least they
> follow the rules and their ACPI and BIOS code say that they are using
> port 80 very clearly if you use PnP and ACPI properly.  And in the old
> days, you were "supposed" to use the system BIOS to talk to things like
> the PIT that had timing issues, not write your own code.

Does anyone know what port does Windows use? I'm pretty sure that it isn't 80h 
as I run Windows 98 often with port 80h debug card inserted. The last POST 
code set by BIOS usually remains on the display and only changes when BIOS 
does something like suspend/resume. IIRC, there was a program that was able 
to display temperature from onboard sensors on the port 80h display that's 
integrated on some mainboards.

-- 
Ondrej Zary
