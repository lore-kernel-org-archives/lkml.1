Return-Path: <linux-kernel-owner+w=401wt.eu-S1760044AbYAYTMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760044AbYAYTMH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 14:12:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753097AbYAYTLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 14:11:54 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39903 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755500AbYAYTLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 14:11:53 -0500
Date: Fri, 25 Jan 2008 11:11:48 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] driver core patches against 2.6.24
In-Reply-To: <20080125185213.GA23475@suse.de>
Message-ID: <alpine.LFD.1.00.0801251108480.2979@hp.linux-foundation.org>
References: <20080125071127.GA4860@kroah.com> <alpine.LFD.1.00.0801251035150.2979@hp.linux-foundation.org> <20080125185213.GA23475@suse.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 25 Jan 2008, Greg KH wrote:
> 
> That's really wierd, I don't see that at all here just running with your
> 2.6.24 + my git tree and lots of USB drivers built into the kernel also
> (like ehci_hcd).

But do you use an initrd that tries to load the same driver too?

I'm too lazy to want to do my own initrd. I just use the prepackaged ones 
and rely on the fact that my private kernel will refuse to load modules 
that aren't meant for it anyway.

> $ cat /proc/sys/kernel/tainted
> 0

Mine says "2".

> $ uname -r
> 2.6.24-ge374a2bf-dirty
> 
> Strange, I thought that the uname id would show the git version that you
> were running, but that doesn't show a valid id.  But that's probably a
> different issue in the build system somewhere...

That *is* the git version you're running: e374a2bf.

The "-g" is for "git" and the "-dirty" is because you have some 
non-checked-in changes in addition.

I works for me:

	[torvalds@hp linux]$ git show --abbrev-commit -s --pretty=oneline e374a2bf
	e374a2b... Kobject: fix coding style issues in kobject c files

so that looks like a valid version..

		Linus
