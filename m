Return-Path: <linux-kernel-owner+w=401wt.eu-S934072AbYDWBGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934072AbYDWBGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 21:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758549AbYDWBGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 21:06:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50169 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756229AbYDWBGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 21:06:45 -0400
Date: Tue, 22 Apr 2008 18:06:16 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Jeff Chua <jeff.chua.linux@gmail.com>, Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Broken] PCI: clean up resource alignment management
In-Reply-To: <200804221551.56502.jbarnes@virtuousgeek.org>
Message-ID: <alpine.LFD.1.10.0804221805460.2779@woody.linux-foundation.org>
References: <b6a2187b0804220943l26f7b441sb5a7309dff0e84dc@mail.gmail.com> <alpine.LFD.1.10.0804221451270.2779@woody.linux-foundation.org> <alpine.LFD.1.10.0804221510420.2779@woody.linux-foundation.org> <200804221551.56502.jbarnes@virtuousgeek.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 22 Apr 2008, Jesse Barnes wrote:

> On Tuesday, April 22, 2008 3:13 pm Linus Torvalds wrote:
> >
> > Now we just need to have somebody test it. It turns out that I no longer
> > have any Cardbus cards, since my laptops now all have built-in wireless.
> > Boo hiss for me.
> 
> I may be in the same boat, I'll have to dig around and see if I have any...  
> That said, I think an explicit alignment field would make things even cleaner 
> (and like you said allow us to take advantage of bus specific alignment 
> better).

Never mind. The error happens even without a card or driver, just plain 
cardbus. 

I'll test the fix and check it in if it looks ok,

		Linus
