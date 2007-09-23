Return-Path: <linux-kernel-owner+w=401wt.eu-S1758624AbXIWTFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624AbXIWTFG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 15:05:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756414AbXIWTE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 15:04:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48781 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756168AbXIWTEz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 15:04:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mihai =?utf-8?q?Don=C8=9Bu?= <mihai.dontu@gmail.com>
Subject: Re: 2.6.23-rc7 + radeonfb/s2ram
Date: Sun, 23 Sep 2007 21:18:09 +0200
User-Agent: KMail/1.9.5
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200709220828.00078.mihai.dontu@gmail.com> <200709232051.39949.mihai.dontu@gmail.com> <200709232131.02348.mihai.dontu@gmail.com>
In-Reply-To: <200709232131.02348.mihai.dontu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200709232118.09884.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 23 September 2007 20:31, Mihai Donțu wrote:
> On Sunday 23 September 2007, Mihai Donțu wrote:
> > I'll to do a full cleanup and start all over. I'm going to nail this thing down if
> > it's the last thing I do! (so help me God) :)
> 
>   Found it!
> 
>   The problem was "Framebuffer Console support". It was enabled by default in older
>   configs (like 2.6.22.7) but I think someone noticed this was bad and put it to
>   default N in newer (2.6.23-rc7); and since I reused the .config from 2.6.21.3 ...
> 
>   So there, if one wants "ATI Radeon display support" on Radeon XPRESS 200M with
>   X using radeon_drv.so, *should* put "Framebuffer Console support" to N (if it's
>   not already).
> 
>   Now all I have to do is figure out what's the equivalent of "vga=791" on the new
>   kernel (default text console looks really bad on my laptop).
> 
>   Sorry for all the noise (and spam),

No, this actually is valuable information, thanks for it. :-)

[I have missed your first post, sorry for that.]

Greetings,
Rafael
