Return-Path: <linux-kernel-owner+w=401wt.eu-S1763809AbYDVWwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763809AbYDVWwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 18:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756554AbYDVWwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 18:52:06 -0400
Received: from outbound-mail-28.bluehost.com ([69.89.17.198]:60402 "HELO
	outbound-mail-28.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755764AbYDVWwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 18:52:05 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Broken] PCI: clean up resource alignment management
Date: Tue, 22 Apr 2008 15:51:56 -0700
User-Agent: KMail/1.9.9
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Jeff Chua <jeff.chua.linux@gmail.com>, Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <b6a2187b0804220943l26f7b441sb5a7309dff0e84dc@mail.gmail.com> <alpine.LFD.1.10.0804221451270.2779@woody.linux-foundation.org> <alpine.LFD.1.10.0804221510420.2779@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0804221510420.2779@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804221551.56502.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 131.252.210.190 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 22, 2008 3:13 pm Linus Torvalds wrote:
> On Tue, 22 Apr 2008, Linus Torvalds wrote:
> > (In fact, I think cardbus bridges have a much more flexible alignment
> > than that size thing, and can be aligned at finer granularity, but I
> > forget the exact details, and since we didn't add a special "alignment"
> > field, we can't take advantage of it anyway).
>
> Yeah, I double-checked: the IO alignment is 4 bytes, the MEM alignment is
> 4k.
>
> So if we had a separate alignment word we could use that, but in the
> meantime I think IORESOURCE_SIZEALIGN is good enough, and a bit more
> readable than the STARTALIGN thing.
>
> Now we just need to have somebody test it. It turns out that I no longer
> have any Cardbus cards, since my laptops now all have built-in wireless.
> Boo hiss for me.

I may be in the same boat, I'll have to dig around and see if I have any...  
That said, I think an explicit alignment field would make things even cleaner 
(and like you said allow us to take advantage of bus specific alignment 
better).

Jesse
