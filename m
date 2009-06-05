Return-Path: <linux-kernel-owner+w=401wt.eu-S1755914AbZFETaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbZFETaB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 15:30:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753079AbZFET3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 15:29:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56411 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752738AbZFET3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 15:29:33 -0400
Date: Fri, 5 Jun 2009 12:22:42 -0700
From: Greg KH <gregkh@suse.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       "Gao, Yunpeng" <yunpeng.gao@intel.com>, Greg KH <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 3 (staging)
Message-ID: <20090605192242.GA4910@suse.de>
References: <20090603190952.2dd0cc70.sfr@canb.auug.org.au> <20090604175219.GA18605@kroah.com> <38D9F46DFF92C54980D2F2C1E8EE313001A45F49F3@pdsmsx503.ccr.corp.intel.com> <200906052058.19875.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906052058.19875.bzolnier@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05, 2009 at 08:58:19PM +0200, Bartlomiej Zolnierkiewicz wrote:
> On Friday 05 June 2009 05:31:21 Gao, Yunpeng wrote:
> > Hi Greg,
> > 
> > Thanks for your quick response.
> > 
> > The root cause of the build-errors in ffsport.c is that the kernel block layer APIs are different in linux-next tree (.../linux/kernel/git/sfr/linux-next.git) than in Linus' kernel tree (.../linux/kernel/git/torvalds/linux-2.6.git).
> > 
> > Yesterday, after modify code in ffsport.c to sync up with the block layer APIs changes, I have make the kernel against linux-next tree and found no build error / warnings.
> > 
> > Then I generated the patch again Linus' kernel tree, tag 'v2.6.30-rc8' and sent the patch to you. This patch uses the new block layer APIs and is target for the linux-next tree.
> > 
> > I guess the below build errors are caused by compiling the patch code in Linus' kernel tree. As the block layer API's in Linus' kernel tree is still the old one, it'll report this kind of 'implicit declaration of function ...' error. I'm sorry for the mis-communication.
> > 
> > Now, I'm a bit confused with the process :-) Which git tree should I select to generate patch against and submit to? The linux-next tree or Linus' kerner tree?
> 
> One solution would be to generate the _main_ patch against Linus' tree
> (for Greg to include in staging tree) and then generate _incremental_
> patch with changes to account for block layer API update (for Stephen
> to include in linux-next)..

Yeah, that would be the best thing.

Sorry about this, but could you send me both patches?  That way I can
merge them both properly when needed.

thanks,

greg k-h
