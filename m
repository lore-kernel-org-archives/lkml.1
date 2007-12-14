Return-Path: <linux-kernel-owner+w=401wt.eu-S1756522AbXLNSxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522AbXLNSxo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 13:53:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756149AbXLNSxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 13:53:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43600 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756127AbXLNSx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 13:53:29 -0500
Message-ID: <4762D005.5060800@zytor.com>
Date: Fri, 14 Dec 2007 10:48:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Rene Herman <rene.herman@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "David P. Reed" <dpreed@reed.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80
 on some AMD64x2 laptops, etc.
References: <1184216528.12353.203.camel@chaos>	<1184218962.12353.209.camel@chaos>	<46964352.7040301@reed.com>	<1184253339.12353.223.camel@chaos>	<469697C6.50903@reed.com>	<1184274754.12353.254.camel@chaos>	<4761F193.7090400@reed.com>	<476250D5.8000409@gmail.com>	<20071214142355.GA10130@elte.hu>	<476294D3.4060609@keyaccess.nl>	<20071214144628.GA16074@elte.hu>	<476299B7.8030908@keyaccess.nl> <20071214183626.4a16e2af@the-village.bc.nu>
In-Reply-To: <20071214183626.4a16e2af@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>>> i dont think this should matter: old systems that truly _need_ the ISA 
>>> delay will be slow enough to not trip up. (nor are they really affected 
>>> by these early delays - the delays were more for crappy ISA devices that 
>>> get initialized later down, when the delay loop is already calibrated)
>> 8253 (DMAC) and 8254 (PIT) have been reported in earlier versions of the 
>> thread. By Alan, I believe.
> 
> They've been seen to be problems up to PII era machines. I'm not aware of
> any newer than that with this problem. We also don't need to touch the
> DMAC that early anyway that I can see - just the PIT.
> 
> In fact if we have a fast processor we have a TSC and APIC so we don't
> need the PIT ?

Well, the TSC may be unstable and the APIC may be disabled.

	-hpa
