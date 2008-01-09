Return-Path: <linux-kernel-owner+w=401wt.eu-S1756521AbYAIWB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521AbYAIWB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 17:01:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbYAIWBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 17:01:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39415 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998AbYAIWBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 17:01:48 -0500
Message-ID: <478543C5.5030401@zytor.com>
Date: Wed, 09 Jan 2008 13:59:33 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Christer Weinigel <christer@weinigel.se>
CC: Zachary Amsden <zach@vmware.com>, Rene Herman <rene.herman@keyaccess.nl>,
       "David P. Reed" <dpreed@reed.com>, Avi Kivity <avi@qumranet.com>,
       Ondrej Zary <linux@rainbow-software.org>, Bodo Eggert <7eggert@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol <rol@witbe.net>
Subject: Re: [linux-kernel] Re: [PATCH] x86: provide a DMI based port 0x80
 I/O delay override.
References: <9BdU5-1YW-9@gated-at.bofh.it>	<200801081810.58904.linux@rainbow-software.org>	<4783B1B2.6070005@reed.com>	<200801081838.16241.linux@rainbow-software.org>	<4783C4A6.9060402@reed.com>	<20080108185120.3ff7ed18@lxorguk.ukuu.org.uk>	<4783CBD9.7020709@reed.com>	<1199847162.7369.323.camel@bodhitayantram.eng.vmware.com>	<20080109063052.48a5709c@weinigel.se>	<4784E7E1.4060308@keyaccess.nl>	<1199902644.7369.355.camel@bodhitayantram.eng.vmware.com>	<47850FE3.2040001@zytor.com> <20080109212615.5908fd3c@weinigel.se>
In-Reply-To: <20080109212615.5908fd3c@weinigel.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christer Weinigel wrote:
> On Wed, 09 Jan 2008 10:18:11 -0800
> "H. Peter Anvin" <hpa@zytor.com> wrote:
> 
>> Zachary Amsden wrote:
>>> I'm speaking specifically in terms of 64-bit platforms here.
>>> Shouldn't we unconditionally drop outb_p doing extra port I/O on
>>> 64-bit architectures?  Especially considering they don't even have
>>> an ISA bus where the decode timing could even matter?
>>>
>> Why should the bitsize of the CPU matter for this?  It seems one of
>> the less meaningful keys for this.
> 
> Well, anything that runs x86_64 should be a fairly modern system.
>  

Yes, but you hardly want a situation where the machine works booting a 
32-bit kernel and not a 64-bit kernel, or vice versa.

Furthermore, it's not so much about "modern" versus "old", it is about 
picking a certain set of bugs.

	-hpa
