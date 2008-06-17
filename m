Return-Path: <linux-kernel-owner+w=401wt.eu-S1760023AbYFQSn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760023AbYFQSn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 14:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759576AbYFQSnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 14:43:05 -0400
Received: from iabervon.org ([66.92.72.58]:54417 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757852AbYFQSnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 14:43:04 -0400
Date: Tue, 17 Jun 2008 14:43:02 -0400 (EDT)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Greg KH <gregkh@suse.de>
cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       arjan@linux.intel.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       tglx@linutronix.de, linville@tuxdriver.com, davej@redhat.com
Subject: Re: Oops report for the week preceding June 16th, 2008
In-Reply-To: <20080617175414.GA9866@suse.de>
Message-ID: <alpine.LNX.1.00.0806171428320.19665@iabervon.org>
References: <4856AFDF.5080901@linux.intel.com> <20080617092023.GA20621@elte.hu> <20080617.022652.76635616.davem@davemloft.net> <20080617153356.GA3510@elte.hu> <20080617175414.GA9866@suse.de>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jun 2008, Greg KH wrote:

> On Tue, Jun 17, 2008 at 05:33:56PM +0200, Ingo Molnar wrote:
> > IMO we are not learning and are repeating history once again, as the 
> > Nouveau situation is building up towards a similar "we didnt merge it in 
> > time" pain point. From kernel-2.6.25.6-24.fc8.src.rpm:
> > 
> >   -rw-r--r-- 1 root root 513639 2008-05-22 04:31 nouveau-drm.patch
> > 
> >   39 files changed, 13960 insertions(+), 5 deletions(-)
> > 
> > Nouveau has been started in 2006, about two years ago. It's a lot less 
> > painful (not the least it is a lot faster as well) if such things are 
> > developed gradually in mainline.
> 
> Not to dispute your original claim of wanting to merge drivers earlier,
> but a lot of the time, there are good reasons why the code doesn't get
> merged.
> 
> As recently pointed out by the nouveau driver authors on the xorg
> mailing list, they don't want the driver to be added to the main
> kernel.org tree yet as they feel that their userspace/kernelspace
> inteface is not complete and will change in the future.

That's the same reason the wireless drivers didn't get merged sooner, with 
the slight difference that they were waiting on the new 802.11 stack's 
interface to stabilize, rather than their own interface.

On the other hand, it would be good if there were a way to include 
unstable APIs in the mainline kernel so that they could get some exposure 
before they're set in stone, and that would also eliminate that reason for 
keeping drivers out so long.

	-Daniel
*This .sig left intentionally blank*
