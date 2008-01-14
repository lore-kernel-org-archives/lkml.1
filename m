Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbYANV65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbYANV65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 16:58:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750968AbYANV6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 16:58:48 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60136 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbYANV6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 16:58:47 -0500
Subject: Re: [linux-kernel] Re: [PATCH] x86: provide a DMI based port 0x80
	I/O delay override.
From: David Woodhouse <dwmw2@infradead.org>
To: "David P. Reed" <dpreed@reed.com>
Cc: Rene Herman <rene.herman@keyaccess.nl>, Zachary Amsden <zach@vmware.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christer Weinigel <christer@weinigel.se>,
       Ondrej Zary <linux@rainbow-software.org>, Bodo Eggert <7eggert@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol <rol@witbe.net>
In-Reply-To: <47877ECD.9060408@reed.com>
References: <9BdU5-1YW-9@gated-at.bofh.it>
	 <200801081810.58904.linux@rainbow-software.org> <4783B1B2.6070005@reed.com>
	 <200801081838.16241.linux@rainbow-software.org> <4783C4A6.9060402@reed.com>
		 <20080108185120.3ff7ed18@lxorguk.ukuu.org.uk> <4783CBD9.7020709@reed.com>
	 <1199847162.7369.323.camel@bodhitayantram.eng.vmware.com>
	 <47845972.9090803@zytor.com>
	 <1199915614.7369.367.camel@bodhitayantram.eng.vmware.com>
	 <47854916.4080703@reed.com>
	 <1200015388.6192.22.camel@bodhitayantram.eng.vmware.com>
	 <4786DD05.20804@keyaccess.nl>  <47877ECD.9060408@reed.com>
Content-Type: text/plain
Date: Tue, 15 Jan 2008 05:57:27 +0800
Message-Id: <1200347847.2647.97.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-3.fc8.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-01-11 at 09:35 -0500, David P. Reed wrote:
>   Using any "unused port" for a delay means that the machine check
> feature is wasted and utterly unusable.

Not entirely unusable. You can recover silently from the machine check
if it was one of the known accesses to the 'unused port'. It certainly
achieves a delay :)

On ppc32 we recover from the machine check if it was any inb/outb --
mostly to work around crappy drivers developed on i386, I believe.

-- 
dwmw2

