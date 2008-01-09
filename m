Return-Path: <linux-kernel-owner+w=401wt.eu-S1753502AbYAIFVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbYAIFVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 00:21:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750859AbYAIFVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 00:21:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49392 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbYAIFVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 00:21:13 -0500
Message-ID: <47845972.9090803@zytor.com>
Date: Tue, 08 Jan 2008 21:19:46 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: "David P. Reed" <dpreed@reed.com>, Avi Kivity <avi@quramnet.com>,
       Christer Weinigel <christer@weinigel.se>,
       Ondrej Zary <linux@rainbow-software.org>,
       Rene Herman <rene.herman@keyaccess.nl>, Bodo Eggert <7eggert@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol <rol@witbe.net>
Subject: Re: [linux-kernel] Re: [PATCH] x86: provide a DMI based port 0x80
 I/O delay override.
References: <9BdU5-1YW-9@gated-at.bofh.it>	 <200801081810.58904.linux@rainbow-software.org>	<4783B1B2.6070005@reed.com>	 <200801081838.16241.linux@rainbow-software.org>	<4783C4A6.9060402@reed.com>	 <20080108185120.3ff7ed18@lxorguk.ukuu.org.uk>  <4783CBD9.7020709@reed.com> <1199847162.7369.323.camel@bodhitayantram.eng.vmware.com>
In-Reply-To: <1199847162.7369.323.camel@bodhitayantram.eng.vmware.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> 
> BTW, it isn't ever safe to pass port 0x80 through to hardware from a
> virtual machine; some OSes use port 0x80 as a hardware available scratch
> register (I believe Darwin/x86 did/does this during boot).

That's funny, because there is definitely no guarantee that you get back 
what you read (well, perhaps there is on Apple.)

	-hpa
