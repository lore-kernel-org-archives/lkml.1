Return-Path: <linux-kernel-owner+w=401wt.eu-S1761357AbZATLtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761357AbZATLtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 06:49:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759130AbZATLtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 06:49:09 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48894 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757200AbZATLtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 06:49:08 -0500
Date: Tue, 20 Jan 2009 06:49:06 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Jacek Luczak <difrost.kernel@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>,
       LKML <linux-kernel@vger.kernel.org>, xfs mailing list <xfs@oss.sgi.com>
Subject: Re: [XFS] 2.6.29-rc2: XFS internal error XFS_WANT_CORRUPTED_GOTO
Message-ID: <20090120114906.GA12526@infradead.org>
References: <497468C1.3000001@gmail.com> <4974CA20.6050308@sandeen.net> <20090120004611.GA6445@disturbed> <20090120112910.GA6831@infradead.org> <4975B9C4.7030401@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4975B9C4.7030401@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 12:47:16PM +0100, Jacek Luczak wrote:
> Christoph Hellwig pisze:
> > On Tue, Jan 20, 2009 at 11:46:11AM +1100, Dave Chinner wrote:
> >> On Mon, Jan 19, 2009 at 12:44:48PM -0600, Eric Sandeen wrote:
> >>> Jacek Luczak wrote:
> >>>> Hi All,
> >>>>
> >>>> I've stepped into XFS issue/bug. Yesterday I've compiled 2.6.29-rc2 and no
> >>>> didn't found errors. Today I've booted my notebook and XFS bug have occurred.
> >>>> System reboot didn't helped, same error appeared.
> >>>>
> >>>> Some info:
> >>>> [1] config: http://pin.if.uz.zgora.pl/~difrost/linux-next/2.6.29-rc2.config
> >>>> [2] kernel logs:
> >>>> http://pin.if.uz.zgora.pl/~difrost/linux-next/2.6.29-rc2_XFS-bug.log
> >>>> [3] most interesting part of log below.
> >>> so this happens every mount?  Reproducible is good.  How large is the
> >>> filesystem (too large to extract elsewhere for analysis...?) (plus I
> >>> suppose it'll be hard to get to it when you can't even boot....)
> >> XFS folks, I suspect the common link between all the reports of this
> >> bug is that they are on 32-bit kernels. I can't reproduce this on
> >> a 64 bit kernel, and I'm trying to get a 32-bit UML built right now
> >> to test this theory.
> > 
> > I'm doing about half of my testing on 32 bit x86, and I couldn't
> > reproduce the detailed receipe  in the kernel.org bugzilla yet.
> > 
> > Just curious:  do you have CONFIG_LBD set?
> > 
> Hi Christoph,
> 
> the answer is:
> $ grep LBD .config
> # CONFIG_LBD is not set

Ok, let me reproduce it without that set..
