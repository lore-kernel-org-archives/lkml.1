Return-Path: <linux-kernel-owner+w=401wt.eu-S1754826AbZDZXXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbZDZXXr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 19:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbZDZXXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 19:23:41 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:63082 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbZDZXXk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 19:23:40 -0400
MIME-Version: 1.0
In-Reply-To: <20090426231208.GA17240@shareable.org>
References: <20090426195249.GC10627@shareable.org> <Pine.LNX.4.44L0.0904261715250.26439-100000@netrider.rowland.org> 
	<20090426213746.GH10627@shareable.org> <ac3eb2510904261536t7a37f970tfafba71d1e67cfb6@mail.gmail.com> 
	<20090426231208.GA17240@shareable.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 27 Apr 2009 01:23:24 +0200
Message-ID: <ac3eb2510904261623g6270b9a4x20252e06fc8d8bf6@mail.gmail.com>
Subject: Re: Wait for console to become available, v3.2
To: Jamie Lokier <jamie@shareable.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, David VomLehn <dvomlehn@cisco.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Linux Embedded Mailing List <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 01:12, Jamie Lokier <jamie@shareable.org> wrote:
> Kay Sievers wrote:
>> > _If_ the system doesn't wait for all block devices present at boot to
>> > be enumerated before the boot script, then when the script looks in
>> > that directory for a specific UUID, it would be good to wait until
>> > "has everything present at boot been enumerated?" says yes.
>>
>> That's what distros do with initramfs today.
>
> I don't see how that's possible.  Haven't we been discussing how the
> USB driver does not have any support (yet) for saying when it's found
> every device present at boot time, and that it can probably be added?

It's easy for the rootfs, or any other mandatory filesystem, unlike it
is for the console stuff.

There is no timeout, distro's initramfs waits for the specified root
device until it appears. It's simple, there is nothing else to do for
it. It does not care what bus it is, or who is probing what for how
long. It loads all drivers it finds hardware for, and then spins until
the device shows up and continues.

Kay
