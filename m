Return-Path: <linux-kernel-owner+w=401wt.eu-S1754685AbXKSADr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbXKSADr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 19:03:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbXKSADj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 19:03:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33878 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbXKSADi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 19:03:38 -0500
Message-ID: <4740D28E.7080800@zytor.com>
Date: Sun, 18 Nov 2007 16:02:22 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Bodo Eggert <7eggert@gmx.de>
CC: Al Boldi <a1426z@gawab.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH][retry-2] init: Introduce rootdir bootparm to select which
 dir to sys_chroot
References: <9qVOO-4ZK-13@gated-at.bofh.it> <E1ItqCg-0003W2-Qu@be1.7eggert.dyndns.org> <47409A48.3000409@zytor.com> <alpine.LSU.0.999.0711190042340.14144@be1.lrz>
In-Reply-To: <alpine.LSU.0.999.0711190042340.14144@be1.lrz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert wrote:
> On Sun, 18 Nov 2007, H. Peter Anvin wrote:
>> Bodo Eggert wrote:
> 
>>> 1) This is useful for booting a rescue or test system, too. In those cases,
>>>    you might want to have the old root moved somewhere.
>>>    (Always "$rootdir/oldroot"? Additional parameter? I'm not sure ...)
>>>
>> Again, this is a good example of why this really shouldn't be additional 
>> hacks in kernel space.
> 
> ACK, but until kinit is default (and Godot arrives), this little hack does 
> seem to be useful.

I disagree, on two accounts:

a. For as long as we keep throwing more crap into the kernel, kinit will 
not get merged, because it "provides no new functionality."

b. You don't need kinit and kernel-tree integeration to do this in an 
external initramfs.  You can do this with any number of codebases as an 
external initramfs.

	-hpa
