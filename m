Return-Path: <linux-kernel-owner+w=401wt.eu-S1756908AbXKBP1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908AbXKBP1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 11:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755433AbXKBP1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 11:27:05 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54925 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716AbXKBP1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 11:27:04 -0400
Date: Fri, 2 Nov 2007 08:26:22 -0700
From: Greg KH <greg@kroah.com>
To: Marcin ?lusarz <marcin.slusarz@gmail.com>
Cc: Jiri Kosina <jikos@jikos.cz>, linux-kernel@vger.kernel.org
Subject: Re: usbserial.ko/option.ko on 2.6.23: Unable to handle kernel
	paging request && inconsistent lock state
Message-ID: <20071102152622.GB7279@kroah.com>
References: <4bacf17f0710291526l6be89bd9o33f02c33186d57b7@mail.gmail.com> <Pine.LNX.4.64.0710300838280.18815@twin.jikos.cz> <4bacf17f0711010259q52db983dqa7fc1f25e6a859d4@mail.gmail.com> <Pine.LNX.4.64.0711011102090.4152@twin.jikos.cz> <4bacf17f0711010755w10f216f4lb059c181c76089ea@mail.gmail.com> <Pine.LNX.4.64.0711011556270.4152@twin.jikos.cz> <4bacf17f0711020139p92125f0gbe78804f80f90e10@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4bacf17f0711020139p92125f0gbe78804f80f90e10@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2007 at 09:39:38AM +0100, Marcin ?lusarz wrote:
> 2007/11/1, Jiri Kosina <jikos@jikos.cz>:
> > On Thu, 1 Nov 2007, Marcin ?lusarz wrote:
> >
> > > > What kernel version are you using? I should have already fixed this one in
> > > > current git -- commit acd2a847
> > > I'm using 2.6.23
> >
> > It got fixed after 2.6.24-rc1.
> I extracted this patch from git and applied on top of 2.6.23 and I
> don't get lockdep warning.

Thanks for letting me know, I'll add it to the -stable series for
2.6.23.

greg k-h
