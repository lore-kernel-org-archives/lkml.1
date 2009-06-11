Return-Path: <linux-kernel-owner+w=401wt.eu-S1762034AbZFKQjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762034AbZFKQjt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 12:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752382AbZFKQjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 12:39:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42972 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751712AbZFKQjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 12:39:42 -0400
Date: Thu, 11 Jun 2009 09:38:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Marcel Holtmann <marcel@holtmann.org>
cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] Performance Counters for Linux
In-Reply-To: <1244738098.27363.36.camel@violet>
Message-ID: <alpine.LFD.2.01.0906110937110.3573@localhost.localdomain>
References: <20090611160329.GA3366@elte.hu>  <20090611161714.GA5008@infradead.org>  <alpine.LFD.2.01.0906110922080.3573@localhost.localdomain> <1244738098.27363.36.camel@violet>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 11 Jun 2009, Marcel Holtmann wrote:
> 
> so do you expect us to merge stuff like ip, iw, rfkill, crda, the WiMAX
> tools, the Bluetooth ones and whatever we have that are all have the
> same issues to be merged into the kernel source code as well.

No. Only stuff that I expect to be really close to hardware, and used for 
kernel purposes.

> Also please consider the distro point of view. All these distros have
> already a hard time to keep up with the kernel patches etc. It is a lot
> easier to update a userspace package then having to provide a patches
> kernel source.

Feel free to split it all up if it turns out to be stable later.

But I refuse to go through another oprofile.

		Linus
