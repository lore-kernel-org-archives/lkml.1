Return-Path: <linux-kernel-owner+w=401wt.eu-S1755482AbYAIVsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482AbYAIVsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 16:48:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbYAIVsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 16:48:09 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:41488 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750825AbYAIVsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 16:48:08 -0500
Subject: Re: [linux-kernel] Re: [PATCH] x86: provide a DMI based port 0x80
	I/O delay override.
From: Zachary Amsden <zach@vmware.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "David P. Reed" <dpreed@reed.com>, Avi Kivity <avi@quramnet.com>,
       Christer Weinigel <christer@weinigel.se>,
       Ondrej Zary <linux@rainbow-software.org>,
       Rene Herman <rene.herman@keyaccess.nl>, Bodo Eggert <7eggert@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol <rol@witbe.net>
In-Reply-To: <47845972.9090803@zytor.com>
References: <9BdU5-1YW-9@gated-at.bofh.it>
	 <200801081810.58904.linux@rainbow-software.org> <4783B1B2.6070005@reed.com>
	 <200801081838.16241.linux@rainbow-software.org> <4783C4A6.9060402@reed.com>
	 <20080108185120.3ff7ed18@lxorguk.ukuu.org.uk> <4783CBD9.7020709@reed.com>
	 <1199847162.7369.323.camel@bodhitayantram.eng.vmware.com>
	 <47845972.9090803@zytor.com>
Content-Type: text/plain
Date: Wed, 09 Jan 2008 13:53:34 -0800
Message-Id: <1199915614.7369.367.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-01-08 at 21:19 -0800, H. Peter Anvin wrote:
> Zachary Amsden wrote:
> > 
> > BTW, it isn't ever safe to pass port 0x80 through to hardware from a
> > virtual machine; some OSes use port 0x80 as a hardware available scratch
> > register (I believe Darwin/x86 did/does this during boot).
> 
> That's funny, because there is definitely no guarantee that you get back 
> what you read (well, perhaps there is on Apple.)

According to Phoenix Technologies book "System BIOS for IBM PCs,
Compatibles and EISA Computers, 2nd Edition", the I/O port list gives

port 0080h   R/W  Extra page register (temporary storage)

Despite looking, I've never seen it documented anywhere else, but I
believe it works on just about every PC platform.  Except, apparently,
my laptop.

Zach

