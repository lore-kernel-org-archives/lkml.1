Return-Path: <linux-kernel-owner+w=401wt.eu-S1755227AbYAHTOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227AbYAHTOr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 14:14:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbYAHTOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 14:14:40 -0500
Received: from ns.gsystems.sk ([62.176.172.50]:51326 "EHLO www.gsystems.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbYAHTOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 14:14:39 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [linux-kernel] Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
Date: Tue, 8 Jan 2008 20:13:32 +0100
User-Agent: KMail/1.9.7
Cc: "David P. Reed" <dpreed@reed.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Rene Herman <rene.herman@keyaccess.nl>,
       Christer Weinigel <christer@weinigel.se>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Paul Rolland <rol@as2917.net>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
References: <9BdU5-1YW-9@gated-at.bofh.it> <200801081838.16241.linux@rainbow-software.org> <alpine.LSU.0.999.0801081950470.3158@be1.lrz>
In-Reply-To: <alpine.LSU.0.999.0801081950470.3158@be1.lrz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801082013.37026.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 January 2008 19:51:41 Bodo Eggert wrote:
> On Tue, 8 Jan 2008, Ondrej Zary wrote:
> > On Tuesday 08 January 2008 18:24:02 David P. Reed wrote:
> > > Windows these days does delays with timing loops or the scheduler.  It
> > > doesn't use a "port".  Also, Windows XP only supports machines that
> > > tend not to have timing problems that use delays.  Instead, if a device
> > > takes a while to respond, it has a "busy bit" in some port or memory
> > > slot that can be tested.
> >
> > Windows XP can run on a machine with ISA slot(s) and has built-in drivers
> > for some plug&play ISA cards - e.g. the famous 3Com EtherLink III. I
> > think that there's a driver for NE2000-compatible cards too and it
> > probably works.
>
> The NE2K-driver went missing in W2K. BTDT.

Haven't tried personally but it seems to work accroding to this 
http://www.windowsnetworking.com/articles_tutorials/wxpne2k.html - and it can 
be made to work even with non-PnP cards.

-- 
Ondrej Zary
