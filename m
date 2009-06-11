Return-Path: <linux-kernel-owner+w=401wt.eu-S1762251AbZFKQrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762251AbZFKQrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 12:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755970AbZFKQrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 12:47:05 -0400
Received: from senator.holtmann.net ([87.106.208.187]:57577 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbZFKQrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 12:47:03 -0400
Subject: Re: [GIT PULL] Performance Counters for Linux
From: Marcel Holtmann <marcel@holtmann.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <alpine.LFD.2.01.0906110937110.3573@localhost.localdomain>
References: <20090611160329.GA3366@elte.hu>
	 <20090611161714.GA5008@infradead.org>
	 <alpine.LFD.2.01.0906110922080.3573@localhost.localdomain>
	 <1244738098.27363.36.camel@violet>
	 <alpine.LFD.2.01.0906110937110.3573@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 11 Jun 2009 18:47:02 +0200
Message-Id: <1244738822.27363.39.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

> > so do you expect us to merge stuff like ip, iw, rfkill, crda, the WiMAX
> > tools, the Bluetooth ones and whatever we have that are all have the
> > same issues to be merged into the kernel source code as well.
> 
> No. Only stuff that I expect to be really close to hardware, and used for 
> kernel purposes.

and where exactly do we draw the line? It is just no clear to me.

> > Also please consider the distro point of view. All these distros have
> > already a hard time to keep up with the kernel patches etc. It is a lot
> > easier to update a userspace package then having to provide a patches
> > kernel source.
> 
> Feel free to split it all up if it turns out to be stable later.
> 
> But I refuse to go through another oprofile.

Point taken on why you wanna do it. No questions asked here. However I
still think it is a bad idea to begin with. The perf tool could very
well has its own repository on git.kernel.org and be maintained side by
side with the kernel.

Regards

Marcel


