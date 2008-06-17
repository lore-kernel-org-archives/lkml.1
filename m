Return-Path: <linux-kernel-owner+w=401wt.eu-S1759264AbYFQRzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759264AbYFQRzr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 13:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755474AbYFQRzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 13:55:40 -0400
Received: from ns2.suse.de ([195.135.220.15]:50511 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186AbYFQRzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 13:55:39 -0400
Date: Tue, 17 Jun 2008 10:54:14 -0700
From: Greg KH <gregkh@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, arjan@linux.intel.com,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, tglx@linutronix.de, linville@tuxdriver.com,
       davej@redhat.com
Subject: Re: Oops report for the week preceding June 16th, 2008
Message-ID: <20080617175414.GA9866@suse.de>
References: <4856AFDF.5080901@linux.intel.com> <20080617092023.GA20621@elte.hu> <20080617.022652.76635616.davem@davemloft.net> <20080617153356.GA3510@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080617153356.GA3510@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2008 at 05:33:56PM +0200, Ingo Molnar wrote:
> IMO we are not learning and are repeating history once again, as the 
> Nouveau situation is building up towards a similar "we didnt merge it in 
> time" pain point. From kernel-2.6.25.6-24.fc8.src.rpm:
> 
>   -rw-r--r-- 1 root root 513639 2008-05-22 04:31 nouveau-drm.patch
> 
>   39 files changed, 13960 insertions(+), 5 deletions(-)
> 
> Nouveau has been started in 2006, about two years ago. It's a lot less 
> painful (not the least it is a lot faster as well) if such things are 
> developed gradually in mainline.

Not to dispute your original claim of wanting to merge drivers earlier,
but a lot of the time, there are good reasons why the code doesn't get
merged.

As recently pointed out by the nouveau driver authors on the xorg
mailing list, they don't want the driver to be added to the main
kernel.org tree yet as they feel that their userspace/kernelspace
inteface is not complete and will change in the future.

We try to respect the authors of the code when not including them into
the kernel tree for situations like this :)

As for why Fedora added it, it might be because they can control both
sides of the boundry with matching packages much easier.

thanks,

greg k-h
