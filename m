Return-Path: <linux-kernel-owner+w=401wt.eu-S1761275AbYAKOxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761275AbYAKOxO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 09:53:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758096AbYAKOw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 09:52:59 -0500
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:42222 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757866AbYAKOw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 09:52:59 -0500
Message-ID: <478781F1.8040406@keyaccess.nl>
Date: Fri, 11 Jan 2008 15:49:21 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "David P. Reed" <dpreed@reed.com>
CC: Zachary Amsden <zach@vmware.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Christer Weinigel <christer@weinigel.se>,
       Ondrej Zary <linux@rainbow-software.org>, Bodo Eggert <7eggert@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol <rol@witbe.net>
Subject: Re: [linux-kernel] Re: [PATCH] x86: provide a DMI based port 0x80
 I/O delay override.
References: <9BdU5-1YW-9@gated-at.bofh.it>	 <200801081810.58904.linux@rainbow-software.org> <4783B1B2.6070005@reed.com>	 <200801081838.16241.linux@rainbow-software.org> <4783C4A6.9060402@reed.com>	 <20080108185120.3ff7ed18@lxorguk.ukuu.org.uk> <4783CBD9.7020709@reed.com>	 <1199847162.7369.323.camel@bodhitayantram.eng.vmware.com>	 <47845972.9090803@zytor.com>	 <1199915614.7369.367.camel@bodhitayantram.eng.vmware.com>	 <47854916.4080703@reed.com> <1200015388.6192.22.camel@bodhitayantram.eng.vmware.com> <4786DD05.20804@keyaccess.nl> <47877ECD.9060408@reed.com>
In-Reply-To: <47877ECD.9060408@reed.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-01-08 15:35, David P. Reed wrote:

> Rene Herman wrote:
>> On 11-01-08 02:36, Zachary Amsden wrote:
>>
>>> FWIW, I fixed the problem locally by recompiling, changing port 80 to 
>>> port 84 in io.h; works great, and doesn't conflict with any occupied 
>>> ports.
>>
>> Might not give you a "proper" delay though. 0xed should be a better 
>> choice...
>>
> I don't think there is any magic here.

Golly, you don't think so? Just commenting on his local hack. Port 0x84 is 
inside the (reserved) DMA page register range and stands a better chance of 
not being echoed onto ISA by various chipsets than 0xed does due to that.

Yes -- on a sane machine it's all useless anyway and with all sane machines 
this discussion would've ended quite some time ago already. It's the insane, 
obsolete legacy junk that's the problem.

Rene.
