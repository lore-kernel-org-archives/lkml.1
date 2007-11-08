Return-Path: <linux-kernel-owner+w=401wt.eu-S1761381AbXKHP3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761381AbXKHP3X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 10:29:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759437AbXKHP3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 10:29:15 -0500
Received: from madara.hpl.hp.com ([192.6.19.124]:57233 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759006AbXKHP3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 10:29:14 -0500
Date: Thu, 8 Nov 2007 07:27:23 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@osdl.org>, perfmon@napali.hpl.hp.com,
       linux-kernel@vger.kernel.org, perfmon2-devel@lists.sourceforge.net
Subject: Re: [PATCH] fix up perfmon to build on -mm
Message-ID: <20071108152723.GC16752@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20071107003454.GA13374@kroah.com> <20071107134255.GE14646@frankl.hpl.hp.com> <20071107174747.GA9918@kroah.com> <20071107175742.GJ14646@frankl.hpl.hp.com> <20071107195320.GA5823@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071107195320.GA5823@kroah.com>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

On Wed, Nov 07, 2007 at 11:53:20AM -0800, Greg KH wrote:
> > > Also, a lot of your per-cpu sysfs files should probably move to debugfs
> > > as they are for debugging only, right?  No need to clutter up sysfs with
> > > them when only the very few perfmon developers would be needing access
> > > to them.
> > > 
> > Yes, this is mostly debugging. If debugfs is meant for this, then I'll
> > be happy to move this stuff over there. Is there some good example of how
> > I could do that based on my current sysfs code?
> 
> There is documentation for debugfs in the kernel api document :)
> 
> And, there are many in-kernel users of debugfs, a grep for
> "debugfs_create_" should show you some examples of how to use this.  If
> you have any questions, please let me know.

I have now removed all the perfmon2 statistics from sysfs and moved them
to debugfs. I must admit, I like it better this way. Debugfs is also so
much easier to program.

Patch has been pushed into my tree. Let me know if you think I can improve
the sysfs code some more.

Thanks.

-- 

-Stephane
