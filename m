Return-Path: <linux-kernel-owner+w=401wt.eu-S1754640AbZFFIzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbZFFIzn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 04:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbZFFIzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 04:55:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:3332 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120AbZFFIzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 04:55:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,315,1241420400"; 
   d="scan'208";a="522263808"
Date: Sun, 7 Jun 2009 00:30:20 +0800
From: Yunpeng Gao <yunpeng.gao@intel.com>
To: Greg KH <gregkh@suse.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Greg KH <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 3 (staging)
Message-ID: <20090606163020.GA27257@intel.com>
References: <20090603190952.2dd0cc70.sfr@canb.auug.org.au> <20090604175219.GA18605@kroah.com> <38D9F46DFF92C54980D2F2C1E8EE313001A45F49F3@pdsmsx503.ccr.corp.intel.com> <200906052058.19875.bzolnier@gmail.com> <20090605192242.GA4910@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090605192242.GA4910@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 06, 2009 at 03:22:42AM +0800, Greg KH wrote:
> On Fri, Jun 05, 2009 at 08:58:19PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > On Friday 05 June 2009 05:31:21 Gao, Yunpeng wrote:
> > > Hi Greg,
> > > 
> > > Thanks for your quick response.
> > > 
> > > The root cause of the build-errors in ffsport.c is that the kernel block layer APIs are different in linux-next tree (.../linux/kernel/git/sfr/linux-next.git) than in Linus' kernel tree (.../linux/kernel/git/torvalds/linux-2.6.git).
> > > 
> > > Yesterday, after modify code in ffsport.c to sync up with the block layer APIs changes, I have make the kernel against linux-next tree and found no build error / warnings.
> > > 
> > > Then I generated the patch again Linus' kernel tree, tag 'v2.6.30-rc8' and sent the patch to you. This patch uses the new block layer APIs and is target for the linux-next tree.
> > > 
> > > I guess the below build errors are caused by compiling the patch code in Linus' kernel tree. As the block layer API's in Linus' kernel tree is still the old one, it'll report this kind of 'implicit declaration of function ...' error. I'm sorry for the mis-communication.
> > > 
> > > Now, I'm a bit confused with the process :-) Which git tree should I select to generate patch against and submit to? The linux-next tree or Linus' kerner tree?
> > 
> > One solution would be to generate the _main_ patch against Linus' tree
> > (for Greg to include in staging tree) and then generate _incremental_
> > patch with changes to account for block layer API update (for Stephen
> > to include in linux-next)..
> 
> Yeah, that would be the best thing.
> 
> Sorry about this, but could you send me both patches?  That way I can
> merge them both properly when needed.
> 
> thanks,
> 
> greg k-h

Hi Greg,

   I have generated the two patches following what Bartlomiej suggested.
   The first one is the _main_ patch against Linus' kernel tree
   (tag v2.6.30-rc8) and the second one is an _incremental patch
   accounting for the block layer API update in linux-next tree.
   I'll send both of them to you later.

   Thanks.

   Rgd,
   Yunpeng

