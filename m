Return-Path: <linux-kernel-owner+w=401wt.eu-S933185AbXD3KSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933185AbXD3KSf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 06:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031517AbXD3KSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 06:18:35 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47072 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932280AbXD3KSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 06:18:33 -0400
Date: Mon, 30 Apr 2007 11:18:31 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Christoph Hellwig <hch@lst.de>, Christoph Hellwig <hch@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: utrace comments
Message-ID: <20070430101831.GA9814@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Christoph Hellwig <hch@lst.de>, Roland McGrath <roland@redhat.com>,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <20061127165138.GA2991@lst.de> <20070430040213.BF9901801A4@magilla.sf.frob.com> <20070430090840.GB31397@infradead.org> <20070430091808.GA11345@flint.arm.linux.org.uk> <20070430092200.GA15773@lst.de> <20070430093331.GB11345@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430093331.GB11345@flint.arm.linux.org.uk>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 10:33:31AM +0100, Russell King wrote:
> > Does the current arm ptrace code support single stepping in kernelspace?
> > If yes we absolutely need to continue to support it.
> 
> single stepping of user space code via standard ptrace calls, yes.
> 
> > > I'd also like to see utrace become *optional*
> > > for architectures to support, rather than as it currently stands as
> > > a *mandatory* requirement when merged.
> > 
> > No way we'd keep both the old ptrace mess and utrace in the same tree.
> 
> Given the stated arguments from yourself and Roland, that only leaves
> one solution to that.
> 
> I have no real problem with a decision being made to drop kernel-based
> single stepping _provided_ we have some replacement strategy in place
> and readily available.  At the moment I've not seen such a strategy.

Umm, no.  A major regression in the ptrace functionality for some
architectures is simply not acceptable.  We can't merge utrace if
we break existing userspace ABIs, and losing single stepping support
is exactly that.
