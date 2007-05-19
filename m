Return-Path: <linux-kernel-owner+w=401wt.eu-S1761134AbXESHxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761134AbXESHxW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 03:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754437AbXESHxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 03:53:15 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:53693 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754078AbXESHxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 03:53:15 -0400
Date: Sat, 19 May 2007 09:52:57 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Philip Pemberton <usenet07@philpem.me.uk>
cc: linux-kernel@vger.kernel.org
Subject: Re: IPv6: 6to4 tunnel randomly cutting out on 2.6.8.1 - any   patches?
In-Reply-To: <f2iif3$3u3$1@sea.gmane.org>
Message-ID: <Pine.LNX.4.61.0705190950370.9015@yvahk01.tjqt.qr>
References: <f2ifnf$ooh$1@sea.gmane.org> <20070517.143409.102123884.davem@davemloft.net>
 <f2iif3$3u3$1@sea.gmane.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 17 2007 22:46, Philip Pemberton wrote:
>> >   I'm currently trying to set IPv6 up on a Linux-based router. The
>> > aforementioned router runs kernel 2.6.8.1, and just about all the
>> > hardware driver modules are binary modules. For the record, I'd love
>> > to upgrade the router to one of the newer kernels, but AIUI I can't do
>> > it because I don't have the source to the bmods. But anyway...
>> 
>> Then don't come here looking for support, because we can't
>> help you.
>
> All I said was "I can't upgrade the kernel". There's nothing stopping me
> patching it, as long as nothing happens to the Ethernet and ATM driver
> interface side of things - this is all protocol-layer stuff and should be well
> away from the EDI.

How can you tell? The binary blobs may have a glitch, flaw, bug, that
makes them write more-or-less random values to random memory locations,
thereby inadvertently killing the functionality of other modules (such
as the ipv6 tunnel).

If the bug happens without the blobs, _then_ one may start figuring out
what (non-binary) modules may cause interaction problems with the ipv6
tunnel (or if it's the tunnel module itself).


	Jan
-- 
