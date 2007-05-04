Return-Path: <linux-kernel-owner+w=401wt.eu-S376136AbXEDU1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S376136AbXEDU1P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 16:27:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S376137AbXEDU1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 16:27:15 -0400
Received: from 1wt.eu ([62.212.114.60]:2493 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S376136AbXEDU1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 16:27:14 -0400
Date: Fri, 4 May 2007 22:27:07 +0200
From: Willy Tarreau <w@1wt.eu>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: =?iso-8859-1?Q?=D8yvind_V=E5gen_J=E6gtnes?= <lorrides@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Routing 600+ vlan's via linux problems (looks like arp problems)
Message-ID: <20070504202707.GE943@1wt.eu>
References: <d20c3b7d0705031325r13834382r38ea31f26965c50@mail.gmail.com> <20070503205341.GB943@1wt.eu> <Pine.LNX.4.61.0705032255080.18504@yvahk01.tjqt.qr> <d20c3b7d0705031412y11f18288t321c097aaad4b38b@mail.gmail.com> <20070503222334.GD943@1wt.eu> <Pine.LNX.4.61.0705040049520.18504@yvahk01.tjqt.qr> <20070504001147.GA31125@1wt.eu> <Pine.LNX.4.61.0705040947170.18504@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0705040947170.18504@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

On Fri, May 04, 2007 at 09:53:31AM +0200, Jan Engelhardt wrote:
> 
> On May 4 2007 02:11, Willy Tarreau wrote:
> >> 
> >> Haha. Would you be happy if it ran on a CF card instead? :>
> >
> >Yes, because at least when you design a system to run on a CF card, you
> >ensure never to write on it because you know that would kill it. Then
> >since you never write on it, it does not wear out and has no problem
> >running for years (unless you bought cheap end-user CF of course).
> 
> Funny, I just installed a 'full' Linux distro on a CF, like with a
> regular harddisk, and it runs in full rw mode. Packing it up in a
> squashfs and running the thing with aufs did not seem worth
> the hassle of setting up a specialized initrd. And then, when you
> need to make one change (firewall), it's faster than recreating the
> sqfs image.
> Will see how it long that lasts.

This is acceptable for a single machine. I do have something similar
(though mostly read-only and with home dirs on NFS) at home as an
always-on browser. But managing a lot of remote machines that way is
often a difficult work, and the risk of losing remote machines increases
with the number of machines, the frequency of updates and the write
rates on the flash.

Packaging an easily upgradable and remotely testable system really
is worth it even for a few tens of machines.

Cheers,
Willy

