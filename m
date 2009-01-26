Return-Path: <linux-kernel-owner+w=401wt.eu-S1754084AbZAZTlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbZAZTlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 14:41:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbZAZTlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 14:41:05 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:38306 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbZAZTlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 14:41:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=UqCic8KTLokWn/7HzxqknQWr23tiNmAVyJk3kdAFC6XH1kQv07a7Xk84rDAR8amC3B
         eqFs89j5iQdACiCfde0XHXR8hee/Pwr2gdeV+aLZyWXIIDIE9Sa4gQZzBD3zdrqqf20b
         83g9+1Q+WStPKfSa2CcSB+98MYb1y0D6oFXEs=
MIME-Version: 1.0
In-Reply-To: <497E0F94.8000003@gmail.com>
References: <Pine.LNX.4.64.0901221205400.27341@melkki.cs.Helsinki.FI>
	 <20090122114237.GA13845@atrey.karlin.mff.cuni.cz>
	 <4978C812.90702@gmail.com> <20090122211052.GA1928@elf.ucw.cz>
	 <4978F47C.6010909@gmail.com> <4978F3CF.2010301@cs.helsinki.fi>
	 <497E0F94.8000003@gmail.com>
Date: Mon, 26 Jan 2009 21:40:59 +0200
X-Google-Sender-Auth: 502d059274b7d3bf
Message-ID: <84144f020901261140j242bb31cg1b2a59a5ae71ae29@mail.gmail.com>
Subject: Re: [PATCH] w35und: fix usb_control_msg() error handling in 
	wb35_probe()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Sandro Bonazzola <sandro.bonazzola@gmail.com>
Cc: Pavel Machek <pavel@suse.cz>, Greg Kroah-Hartman <greg@kroah.com>,
       linux-kernel@vger.kernel.org,
       Linux Netdev List <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sandro,

Pekka Enberg ha scritto:
>> Ok, test done with git current version of w35und over 2.6.28-gentoo-r1
>> (2.6.28.1 and some patches)
>
> Adding Pekka's patch

On Mon, Jan 26, 2009 at 9:31 PM, Sandro Bonazzola
<sandro.bonazzola@gmail.com> wrote:
>> # uname -a
>> Linux arilinn 2.6.28-gentoo-r1 #1 Wed Jan 21 19:37:07 CET 2009 x86_64 AMD
>> Athlon(tm) 64 Processor 3500+ AuthenticAMD GNU/Linux

[snip]

> Ok, with kernel 2.6.8.1, and your patch it seems to work with channel 1, no
> encryption, opensystem authentication.

So the driver doesn't work in 2.6.29-rc1 but does in 2.6.28.1? I
wonder what changed in the networking/wireless stack that broke the
winbond driver.... I'm cc'ing netdev even though this is a driver in
staging.

                                     Pekka
