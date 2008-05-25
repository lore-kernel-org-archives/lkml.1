Return-Path: <linux-kernel-owner+w=401wt.eu-S1753559AbYEYWiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbYEYWiW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 18:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbYEYWiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 18:38:12 -0400
Received: from colo.lackof.org ([198.49.126.79]:34961 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269AbYEYWiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 18:38:11 -0400
Date: Sun, 25 May 2008 16:37:57 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Grant Grundler <grundler@parisc-linux.org>, Ingo Molnar <mingo@elte.hu>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: early dump pci conf space v2
Message-ID: <20080525223757.GA22343@colo.lackof.org>
References: <200805210012.35939.yhlu.kernel@gmail.com> <200805221435.11734.yhlu.kernel@gmail.com> <20080523053822.GA28835@colo.lackof.org> <86802c440805222338w3c8e946eree2d090ce12609e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440805222338w3c8e946eree2d090ce12609e@mail.gmail.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 11:38:24PM -0700, Yinghai Lu wrote:
...
> > Having debugged lots of PCI resource and config issues, I understand
> > why this is useful and do NOT object to it being included in the tree.
> 
> could print out the setting from buggy BIOS, or first kernel.
> and don't need the reporter apply debug patch again...

Yes, I understood. Here are some more details on why my first
reaction was negative:
o Most of the time the system can boot anyway and we get lspci -v output,
  /proc/iomem, etc. If that's not true, then other parts of the kernel
  need to be more robust (e.g. drivers crashing because resources aren't
  assigned.

o Bringing up linux on a new platform is NOT something we've generally
  had to do via email. Usually someone with kernel/IO experience is
  involved and can build new kernels.

> > At least if you want people to use it. :)
> > Perhaps Jesse can suggest a preferred location.
> 
> we could add it.
> ..
> >
> > Please call this "pci_early_dump" (I prefer with underscores but don't care).
> > Don't want it confused with kernel dumps (LKCD) or any other
> > general debugging tools.
> 
> so you want pci_early_dump instead of pci=earlydump?
> or pci=early_dump?

Sorry, I misread the patch.
I was thinking of "pci_early_dump" as a seperate option but
either "pci=" option is fine.

thanks,
grant
