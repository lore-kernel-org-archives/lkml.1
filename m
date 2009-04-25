Return-Path: <linux-kernel-owner+w=401wt.eu-S1753959AbZDYDLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbZDYDLV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 23:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbZDYDLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 23:11:05 -0400
Received: from netrider.rowland.org ([192.131.102.5]:52419 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750884AbZDYDLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 23:11:04 -0400
Date: Fri, 24 Apr 2009 23:11:03 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Jamie Lokier <jamie@shareable.org>
cc: David VomLehn <dvomlehn@cisco.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Linux Embedded Mailing List <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Wait for console to become available, v3.2
In-Reply-To: <20090425014152.GD23106@shareable.org>
Message-ID: <Pine.LNX.4.44L0.0904242309300.3926-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Apr 2009, Jamie Lokier wrote:

> I'm thinking this broader use:
> 
>     - My boot _script_ is waiting for a disk which identifies as
>       UUID=392852908752345749857 to appear before it can mount it on
>       /data.  If there's no such disk, it proceeds without it.  It's a
>       USB disk, behind a USB hub.
> 
>     - My boot script is looking to see if I'm holding down 'z' on the
>       keyboard, to do something different.  But how does it know if
>       there's a USB keyboard plugged in (behind two USB hubs) that
>       hasn't finished being detected?
> 
> It just seemed to fit comfortably into what's being discussed.

Are you suggesting this new interface be exported to userspace somehow?

Alan Stern

