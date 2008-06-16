Return-Path: <linux-kernel-owner+w=401wt.eu-S1757079AbYFPRt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079AbYFPRt6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 13:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751940AbYFPRtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 13:49:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:37065 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbYFPRtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 13:49:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,653,1204531200"; 
   d="scan'208";a="578484421"
Date: Mon, 16 Jun 2008 10:49:48 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Simon Holm =?iso-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Patrick McHardy <kaber@trash.net>,
       Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Chuck Ebbert <cebbert@redhat.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: 2.6.26-git: NULL pointer deref in __switch_to
Message-ID: <20080616174948.GB7788@linux-os.sc.intel.com>
References: <4852B19E.4010202@trash.net> <19f34abd0806131124w32133715o3ef8c27cb0a9f96e@mail.gmail.com> <20080613224711.GA15084@linux-os.sc.intel.com> <1213611339.2495.11.camel@odie.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1213611339.2495.11.camel@odie.local>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2008 at 03:15:39AM -0700, Simon Holm Thøgersen wrote:
> fre, 13 06 2008 kl. 15:47 -0700, skrev Suresh Siddha:
> > On Fri, Jun 13, 2008 at 11:24:01AM -0700, Vegard Nossum wrote:
> > > On Fri, Jun 13, 2008 at 7:42 PM, Patrick McHardy <kaber@trash.net> wrote:
> > > > I get this oops once a day, its apparently triggered by something
> > > > run by cron, but the process is a different one each time.
> > > >
> > > > Kernel is -git from yesterday shortly before the -rc6 release
> > > > (last commit is the usb-2.6 merge, the x86 patches are missing),
> > > > .config is attached.
> > > >
> > > > I'll retry with current -git, but the patches that have gone in
> > > > since I last updated don't look related.
> > > >
> > >
> > > Thanks for the report.
> > >
> > > >
> > > > [62060.043009] BUG: unable to handle kernel NULL pointer dereference at
> > > > 000001ff
> > > > [62060.043009] IP: [<c0102a9b>] __switch_to+0x2f/0x118
> > > > [62060.043009] *pde = 00000000
> > > > [62060.043009] Oops: 0002 [#1] PREEMPT
> >
> > Patrick, Do you see any other error messages before this BUG stmt? Can you
> > please provide the complete kernel log till the point of failure?
> >
> Suresh, I'm pretty sure this is the same problem that I reported two
> weeks ago [1]. I suggested that you tried running lguest and reproduced
> the problem locally, but I did not hear back from you. Now Patrick is
> reporting the same problem and is also indicating that the problem is
> correlated with his use of lguest, so I'd really like you to follow up
> on this.

I am on this and did try reproducing with lguest last week but couldn't
reproduce the issue with the initrd image. May be I need a full blown
disk image.

> At least for me, with this patch applied on top of -rc4 or -rc6+ the
> problem still triggered after running an lguest guest for less than 30
> seconds (the guest didn't even finish the boot of an image of Ubuntu
> with no X-server).

Please post the oops you captured.

> If you or anybody else would like to use the same guest image I use
> please just ask and I'll make it available somehow.

Can you please upload it some where? I will also try with another guest
image meanwhile.

thanks,
suresh
