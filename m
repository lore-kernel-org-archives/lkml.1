Return-Path: <linux-kernel-owner+w=401wt.eu-S1757103AbXJKFyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103AbXJKFyb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 01:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753515AbXJKFyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 01:54:24 -0400
Received: from lixom.net ([66.141.50.11]:36057 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394AbXJKFyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 01:54:23 -0400
Date: Thu, 11 Oct 2007 00:59:41 -0500
From: Olof Johansson <olof@lixom.net>
To: Paul Mackerras <paulus@samba.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>, linuxppc-dev@ozlabs.org,
       tgall.foo@gmail.com, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org
Subject: Re: [PATCH v2] powerpc: don't enable cpu hotplug on mpic-based
	pseries
Message-ID: <20071011055941.GA1783@lixom.net>
References: <20071008180406.052382073@mini.kroah.org> <20071008180633.GJ7627@kroah.com> <20071009151702.GA19209@lixom.net> <20071009222003.GA21228@kroah.com> <alpine.LFD.0.9999.0710100120340.7766@localhost.localdomain> <alpine.LFD.0.999.0710091625520.3838@woody.linux-foundation.org> <20071010000815.GB7875@lixom.net> <20071010101826.186f1f24.sfr@canb.auug.org.au> <20071010003824.GA8477@lixom.net> <18189.47620.466515.645055@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18189.47620.466515.645055@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2007 at 03:52:04PM +1000, Paul Mackerras wrote:
> Olof Johansson writes:
> 
> > Don't allow cpu hotplug on systems lacking XICS interrupt controller,
> > since current code is hardcoded for it.
> ...
> > +	for (np = NULL; (np = of_find_node_by_name(np,
> > +						   "interrupt-controller"));) {
> 
> Looks like for_each_node_by_name would be nicer here.
> 
> If you agree, I'll hand-edit your patch to do that and apply it.

Go for it, I just stole that out of the detection code. That
could be changed accordingly as well at some point (I'm guessing
for_each_node_by_name didn't exist when that was written).

> Of course, ultimately we should implement the necessary mpic bits to
> support cpu hotplug.

Yep. I'll leave that to people who have hardware access. :-)


Thanks,

-Olof
