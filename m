Return-Path: <linux-kernel-owner+w=401wt.eu-S1761678AbYENBEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761678AbYENBEt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 21:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757483AbYENBEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 21:04:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50601
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758349AbYENBEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 21:04:40 -0400
Date: Tue, 13 May 2008 18:04:34 -0700 (PDT)
Message-Id: <20080513.180434.164938081.davem@davemloft.net>
To: gregkh@suse.de
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       stable@kernel.org, jmforbes@linuxtx.org, zwane@arm.linux.org.uk,
       tytso@mit.edu, rdunlap@xenotime.net, davej@redhat.com,
       chuckw@quantumlinux.com, reviews@ml.cw.f00f.org, mkrufky@linuxtv.org,
       cebbert@redhat.com, cavokz@gmail.com, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 25/37] sparc: Fix mremap address range validation.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080513203705.GA488@suse.de>
References: <20080513201229.GZ31167@suse.de>
	<alpine.LFD.1.10.0805131327130.3019@woody.linux-foundation.org>
	<20080513203705.GA488@suse.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@suse.de>
Date: Tue, 13 May 2008 13:37:05 -0700

> On Tue, May 13, 2008 at 01:28:32PM -0700, Linus Torvalds wrote:
> > 
> > 
> > On Tue, 13 May 2008, Greg KH wrote:
> > >
> > > From: David S. Miller <davem@davemloft.net>
> > > 
> > > Just like mmap, we need to validate address ranges regardless
> > > of MAP_FIXED.
> > 
> > Hmm. I don't have this one in my tree. Is it obsoleted by the other 
> > patches I do have, or what? If so, some comment about that would be nice.
> 
> Odd, I missed that.  David, did you just forget to send this one?

I wanted to clear something else of my sparc tree before pushing
it to Linus and I didn't get to that last night before passing
out.

I'll get it to him tonight.
