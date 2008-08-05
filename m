Return-Path: <linux-kernel-owner+w=401wt.eu-S1761594AbYHERJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761594AbYHERJQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 13:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758684AbYHERJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 13:09:03 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44177 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757417AbYHERJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 13:09:01 -0400
Date: Tue, 5 Aug 2008 10:03:07 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Eric Paris <eparis@redhat.com>, malware-list@lists.printk.net,
       linux-kernel@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface
	for on access scanning
Message-ID: <20080805170307.GB9639@kroah.com>
References: <1217883616.27684.19.camel@localhost.localdomain> <20080804223249.GA10517@kroah.com> <1217896374.27684.53.camel@localhost.localdomain> <20080805005132.GA3661@kroah.com> <20080805122328.69a37c1d@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080805122328.69a37c1d@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 12:23:28PM +0100, Alan Cox wrote:
> > > It may be possible to do in glibc, LD_PRELOAD doesn't exactly work for
> > > suid binaries
> > 
> > Are suid binaries something that you feel is necessary to scan from?
> > 
> > I don't see it on the list above :)
> 
> Doesn't work very well really does it - ld.so loads files too and can be
> attacked.

But that's an "attack" vector, which virus scanners are not addressing.
They are going for the "is this file corrupted" type issue.  The
"normal" LSM interface is for malware itself, taking control of a
system.

thanks,

greg k-h
