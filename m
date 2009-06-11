Return-Path: <linux-kernel-owner+w=401wt.eu-S1762537AbZFKQr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762537AbZFKQr3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 12:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757724AbZFKQrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 12:47:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42323 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582AbZFKQrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 12:47:04 -0400
Date: Thu, 11 Jun 2009 12:46:56 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Marcel Holtmann <marcel@holtmann.org>,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] Performance Counters for Linux
Message-ID: <20090611164656.GA12202@infradead.org>
References: <20090611160329.GA3366@elte.hu> <20090611161714.GA5008@infradead.org> <alpine.LFD.2.01.0906110922080.3573@localhost.localdomain> <1244738098.27363.36.camel@violet> <alpine.LFD.2.01.0906110937110.3573@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906110937110.3573@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 09:38:32AM -0700, Linus Torvalds wrote:
> > so do you expect us to merge stuff like ip, iw, rfkill, crda, the WiMAX
> > tools, the Bluetooth ones and whatever we have that are all have the
> > same issues to be merged into the kernel source code as well.
> 
> No. Only stuff that I expect to be really close to hardware, and used for 
> kernel purposes.

Did you take a look a tools/perf/?  There is nothing close to hardware
at all.  It's all pretty highly abstracted away from anything resembling
the hardware through the perfcounters interface.

