Return-Path: <linux-kernel-owner+w=401wt.eu-S1756177AbYAIU02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbYAIU02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 15:26:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753884AbYAIU0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 15:26:18 -0500
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:36038 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750AbYAIU0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 15:26:17 -0500
Date: Wed, 9 Jan 2008 21:26:15 +0100
From: Christer Weinigel <christer@weinigel.se>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Zachary Amsden <zach@vmware.com>, Rene Herman <rene.herman@keyaccess.nl>,
       "David P. Reed" <dpreed@reed.com>, Avi Kivity <avi@qumranet.com>,
       Ondrej Zary <linux@rainbow-software.org>, Bodo Eggert <7eggert@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol <rol@witbe.net>
Subject: Re: [linux-kernel] Re: [PATCH] x86: provide a DMI based port 0x80
 I/O delay override.
Message-ID: <20080109212615.5908fd3c@weinigel.se>
In-Reply-To: <47850FE3.2040001@zytor.com>
References: <9BdU5-1YW-9@gated-at.bofh.it>
	<200801081810.58904.linux@rainbow-software.org>
	<4783B1B2.6070005@reed.com>
	<200801081838.16241.linux@rainbow-software.org>
	<4783C4A6.9060402@reed.com>
	<20080108185120.3ff7ed18@lxorguk.ukuu.org.uk>
	<4783CBD9.7020709@reed.com>
	<1199847162.7369.323.camel@bodhitayantram.eng.vmware.com>
	<20080109063052.48a5709c@weinigel.se>
	<4784E7E1.4060308@keyaccess.nl>
	<1199902644.7369.355.camel@bodhitayantram.eng.vmware.com>
	<47850FE3.2040001@zytor.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Jan 2008 10:18:11 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> Zachary Amsden wrote:
> > 
> > I'm speaking specifically in terms of 64-bit platforms here.
> > Shouldn't we unconditionally drop outb_p doing extra port I/O on
> > 64-bit architectures?  Especially considering they don't even have
> > an ISA bus where the decode timing could even matter?
> > 
> 
> Why should the bitsize of the CPU matter for this?  It seems one of
> the less meaningful keys for this.

Well, anything that runs x86_64 should be a fairly modern system.
 
> Second, as I have mentioned, I don't believe this is really the case, 
> especially not for the PIT, which is still present -- the PIT 
> *semantics* has explicit timing constraints.
> 
> Third, you still have ISA devices, they're just called LPC or PC104 
> devices these days.

Or PCMCIA.  I'm still a happy user of a Zyxel ZyAIR 100B, it's one of
the most stable cards Wifi I've got running under Linux.   :-)

  /Christer
