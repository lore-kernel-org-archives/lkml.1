Return-Path: <linux-kernel-owner+w=401wt.eu-S1755647AbZDZXrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647AbZDZXrh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 19:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753754AbZDZXrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 19:47:08 -0400
Received: from mail2.shareable.org ([80.68.89.115]:33695 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362AbZDZXrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 19:47:06 -0400
Date: Mon, 27 Apr 2009 00:46:42 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, David VomLehn <dvomlehn@cisco.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Linux Embedded Mailing List <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Wait for console to become available, v3.2
Message-ID: <20090426234642.GC17240@shareable.org>
References: <20090426195249.GC10627@shareable.org> <Pine.LNX.4.44L0.0904261715250.26439-100000@netrider.rowland.org> <20090426213746.GH10627@shareable.org> <ac3eb2510904261536t7a37f970tfafba71d1e67cfb6@mail.gmail.com> <20090426231208.GA17240@shareable.org> <ac3eb2510904261623g6270b9a4x20252e06fc8d8bf6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ac3eb2510904261623g6270b9a4x20252e06fc8d8bf6@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> On Mon, Apr 27, 2009 at 01:12, Jamie Lokier <jamie@shareable.org> wrote:
> > Kay Sievers wrote:
> >> > _If_ the system doesn't wait for all block devices present at boot to
> >> > be enumerated before the boot script, then when the script looks in
> >> > that directory for a specific UUID, it would be good to wait until
> >> > "has everything present at boot been enumerated?" says yes.
> >>
> >> That's what distros do with initramfs today.
> >
> > I don't see how that's possible.  Haven't we been discussing how the
> > USB driver does not have any support (yet) for saying when it's found
> > every device present at boot time, and that it can probably be added?
> 
> It's easy for the rootfs, or any other mandatory filesystem, unlike it
> is for the console stuff.
> 
> There is no timeout, distro's initramfs waits for the specified root
> device until it appears. It's simple, there is nothing else to do for
> it. It does not care what bus it is, or who is probing what for how
> long. It loads all drivers it finds hardware for, and then spins until
> the device shows up and continues.

Ok.  I'm specifically _not_ talking about mandatory filesystems.
Thanks :-)

-- Jamie
