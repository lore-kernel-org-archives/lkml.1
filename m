Return-Path: <linux-kernel-owner+w=401wt.eu-S1750699AbXCOSAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750699AbXCOSAB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 14:00:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbXCOSAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 14:00:00 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:26805 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbXCOSAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 14:00:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dBVTPXRTwIxOOjMWuyyS7VrY9YUhmzf398Zrpj6mfrV6UvCIuiIbvSTf62vCvQUyGKC1ODzcESk8bVIXnKY92AaAKWwHGRUYeufiu/Ho4g4ktQgFKIz8ZdB5aewl2jdZdv6UdoGubGPMEl7wqkEnMkDt7ERcwt1Bh1kBgUwYzw8=
Message-ID: <d120d5000703151059j5bad6b09h45b2f135c42b3324@mail.gmail.com>
Date: Thu, 15 Mar 2007 13:59:45 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Jiri Kosina" <jikos@jikos.cz>
Subject: Re: USB Keyboard
Cc: "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       "Linux kernel" <linux-kernel@vger.kernel.org>,
       linux-usb-devel@lists.sourceforge.net
In-Reply-To: <Pine.LNX.4.64.0703151851190.12394@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.61.0703151331060.4442@chaos.analogic.com>
	 <Pine.LNX.4.64.0703151835150.12394@twin.jikos.cz>
	 <Pine.LNX.4.61.0703151345010.4487@chaos.analogic.com>
	 <Pine.LNX.4.64.0703151851190.12394@twin.jikos.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/15/07, Jiri Kosina <jikos@jikos.cz> wrote:
> (added linux-usb-devel@lists.sourceforge.net to CC)
>
> On Thu, 15 Mar 2007, linux-os (Dick Johnson) wrote:
>
> > >> I have multiple AMD 64-bit servers in several configurations, with
> > >> several different motherboards, which fail to recognize a USB keyboard
> > >> when booted from a "stock" Linux kernel. They only work with a RedHat
> > >> kernel! I have removed all but one CPU from one in an attempt to find
> > >> the problem.
> > > [...]
> > >> linux-2.6.8 linux-2.6.9 linux-2.6.10 linux-2.6.11
> > >> linux-2.6.11.9 linux-2.6.12 linux-2.6.12.5 linux-2.6.13
> > >> linux-2.6.13.4 linux-2.6.15.4 linux-2.6.16.24 linux-2.6.16.4
> > >> linux-2.6.19
> > > Could you please turn on USB debugging (and also maybe HID debugging, but
> > > usb debug should be more interesting now) and send us the logs?
> > Ouch!  I can't do anything by copy from a screen! There is no way to get
> > `dmesg` without the keyboard! That's why I sent a request to
> > linux-kernel, hoping that the problem would sound familiar. All I can do
> > is boot the system (off a CD-ROM) and then pull the plug when the
> > keyboad doesn't work!
>
> You state that this happens on different hardware configurations, which
> looks pretty strange, there are many 64bit amd systems with working USB
> keyboards.
>
> Do you happen to have USB Legacy setting in BIOS? If so, could you try
> turning it off?
>
> Also, does this happen only with one particular type of keyboard, or with
> various ones?
>

Seeing .config might also be interesting.

-- 
Dmitry
