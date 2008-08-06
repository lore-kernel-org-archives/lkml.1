Return-Path: <linux-kernel-owner+w=401wt.eu-S1760395AbYHFH5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760395AbYHFH5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 03:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756434AbYHFH5B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 03:57:01 -0400
Received: from ik-out-1112.google.com ([66.249.90.182]:36662 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756032AbYHFH4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 03:56:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id:from;
        b=CpcjNq7Isn0xNg7k/dDrwzxkrM3MORa3q4zyGNGRfwZnYoZq7OjVlsFiaDZJJGQKe3
         cFNpX4cKBUA4KGedJHGiw6MAExwo+krFa95pZnVYGFMUusrBVIsWX5cY5QycmFrE/xzc
         IWe/9NTzotrnn8B4QKFbiVqfsb3QJy9g+wC4g=
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT]: Networking
Date: Wed, 6 Aug 2008 10:22:02 +0200
User-Agent: KMail/1.9.9
Cc: Marcel Holtmann <marcel@holtmann.org>, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20080805.190020.244441681.davem@davemloft.net> <A0AAD67C-1F54-4D85-A413-91BBBE044452@holtmann.org> <alpine.LFD.1.10.0808052308080.15995@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808052308080.15995@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808061022.02432.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 August 2008, Linus Torvalds wrote:
> 
> On Wed, 6 Aug 2008, Marcel Holtmann wrote:
> > 
> > I looked at the driver and got it working. However my 901 seems to have an
> > issue with the antennas. I can do scans, but associating with an access point
> > or even thinking about transmit keeps failing. Even with external antennas
> > this still doesn't work. So either my EeePC is broken or it needs some ACPI
> > magic to enable it. Personally I think mine is broken since the PCIe hotplug
> > stuff works for the wireless card and that seems to be their way of doing the
> > rfkill.
> 
> Yeah, the rfkill literally makes the chip go away from the PCI lists, it 
> seems. But your problems can certainly be somehow driver-related, I 
> haven't actually _tested_ that thing at all, I got the machine just as the 
> merge window started, so I've had no time to even play with it.
> 
> > The driver itself is painful. It is full of ifdefs and some crazy build magic.
> > The integrated (to some degree optional) WPA code is pretty ugly. It has also
> > a full set of iwpriv commands to do all the settings etc. :(
> 
> Well, it's also trying to support both 2.4.x and 2.6 etc. Yeah, that is 
> horrid. At the same time, I can't say that the "rewrite it entirely" 
> approach of the previous-gen cards has worked very well either, since that 
> seems to have just perpetuated the problems. It would be great to try to 
> educate them, but I'm not finding even an email address in the sources.

I've send a mail to Ralink with a request if they could step away from the
"port the windows driver to linux" idea and get the Linux driver "kernel-ready"
early on.
That won't solve the problem now, but hopefully it does mean the drivers for
the next generation can go into the kernel sooner.

> Oh well. I can't really complain, since just the fact that they bothered 
> to even make sources available still makes them pretty responsible people, 
> even if the sources are pretty dang ugly.
> 
> All the capitalization etc makes me think they are all old DOS and Windows 
> programmers. UCHAR and USHORT indeed, along with CamelCase functions. 

Well it basically is the Windows driver ported to Linux. ;)

Ivo
