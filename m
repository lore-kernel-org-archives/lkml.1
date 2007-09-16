Return-Path: <linux-kernel-owner+w=401wt.eu-S1755458AbXIPDSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbXIPDSw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 23:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754637AbXIPDSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 23:18:45 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57735 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638AbXIPDSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 23:18:44 -0400
Date: Sun, 16 Sep 2007 05:18:43 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Andi Kleen <ak@suse.de>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Martin Mares <mj@ucw.cz>,
       dean gaudet <dean@arctic.org>, Robert Richter <robert.richter@amd.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: set cfg_size for AMD Family 10h in case MMCONFIG is used
Message-ID: <20070916031843.GE14501@one.firstfloor.org>
References: <200709121921.43950.yinghai.lu@sun.com> <200709131147.43446.ak@suse.de> <20070913104704.GA3878@kroah.com> <200709131353.15752.ak@suse.de> <86802c440709131001w4b758921r52a23f1732a6e9c8@mail.gmail.com> <46E97178.2040903@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46E97178.2040903@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2007 at 10:20:56AM -0700, H. Peter Anvin wrote:
> Yinghai Lu wrote:
> > 
> > BIOS guys also said that fam 10h need mmconfig via eax accessing, may
> > need OS do sth, so it is safe to stay with MCFG entry for SB like
> > mcp55...
> > 
> > but latest kernel already have that workaround to make mmconfig via eax...
> > 
> 
> This is actually a good point.  Since the CPU vendor managed to
> completely fuck up the operation of MMCONFIG itself on this CPU (it's a
> *MEMORY REFERENCE*, guys!), it is actually to be expected and prudent

It's quite possible that Windows MCFG code always ends up using EAX. 
In fact many older Linux kernels ended up doing this by chance too.

-Andi
