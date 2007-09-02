Return-Path: <linux-kernel-owner+w=401wt.eu-S934010AbXIBPoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934010AbXIBPoW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 11:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757648AbXIBPny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 11:43:54 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42445 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757501AbXIBPnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 11:43:53 -0400
Date: Sun, 2 Sep 2007 17:43:51 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: the Linux kernel, testsuites, and maybe *you*
Message-ID: <20070902154351.GA21230@one.firstfloor.org>
References: <8bd0f97a0708311422u309ff09cs24dfe64ff535a982@mail.gmail.com> <p733axyxcli.fsf@bingen.suse.de> <8bd0f97a0709011550y833fb5ax7d40cae937789fd8@mail.gmail.com> <20070902065926.GA15487@one.firstfloor.org> <8bd0f97a0709020815r75fcb225lf44bcb57783b436c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0709020815r75fcb225lf44bcb57783b436c@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 02, 2007 at 11:15:23AM -0400, Mike Frysinger wrote:
> there is still the ABI issue ... code written in kernel space in pure
> asm cannot always be compiled in userspace and work properly/the same

Is that a blackfin weirdness? 

> 
> > The other issue to test some of them properly you need unmapped pages
> > etc. That gets much easier to do in user space. There are some other
> > issues.
> 
> you mean testing boundary overflows ?  can be handled with canaries
> rather than segfaults i imagine ...

Not for reads, no.

-Andi
