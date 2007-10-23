Return-Path: <linux-kernel-owner+w=401wt.eu-S1753055AbXJWUha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbXJWUha (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 16:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbXJWUhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 16:37:23 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:55352 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062AbXJWUhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 16:37:22 -0400
Message-ID: <471E5B74.8030900@garzik.org>
Date: Tue, 23 Oct 2007 16:37:08 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, lguest <lguest@ozlabs.org>,
       virtualization@lists.linux-foundation.org,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] lguest: paravirt boot code
References: <200710221237.14542.rusty@rustcorp.com.au> <alpine.LFD.0.999.0710221927131.30120@woody.linux-foundation.org> <200710231603.21620.rusty@rustcorp.com.au> <alpine.LFD.0.999.0710230903330.30120@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710230903330.30120@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 23 Oct 2007, Rusty Russell wrote:
>> Well, with that out the way, and some scatterlist fixups, please pull from
>>
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-lguest.git

Also, please add a "lguest: " prefix to all future commits.

Otherwise, in the one-line summary, it is impossible to tell what 
portion of the kernel is being updated:

	Use "struct boot_params" in example launcher
	Loading bzImage directly.
	Rename "cr3" to "gpgdir" to avoid x86-specific naming.
	Pagetables to use normal kernel types
	Move register setup into i386_core.c
	Accept elf files that are valid but have sections that can not
		be mmap'ed for some reason.

git tools are all keyed to use that first line as a summary of the 
changeset, without giving any other context whatsoever.  See Linus's 
2.6.X-rcY announcements, for example.

This is also described in akpm's 
http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt or my 
http://linux.yyz.us/patch-format.html

	Jeff


