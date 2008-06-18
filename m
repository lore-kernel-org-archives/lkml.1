Return-Path: <linux-kernel-owner+w=401wt.eu-S1760174AbYFRClG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760174AbYFRClG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 22:41:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759656AbYFRCky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 22:40:54 -0400
Received: from iabervon.org ([66.92.72.58]:58752 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759626AbYFRCky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 22:40:54 -0400
Date: Tue, 17 Jun 2008 22:40:52 -0400 (EDT)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Greg KH <gregkh@suse.de>
cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       arjan@linux.intel.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       tglx@linutronix.de, linville@tuxdriver.com, davej@redhat.com
Subject: Re: Oops report for the week preceding June 16th, 2008
In-Reply-To: <20080617224856.GA16933@suse.de>
Message-ID: <alpine.LNX.1.00.0806171852550.19665@iabervon.org>
References: <4856AFDF.5080901@linux.intel.com> <20080617092023.GA20621@elte.hu> <20080617.022652.76635616.davem@davemloft.net> <20080617153356.GA3510@elte.hu> <20080617175414.GA9866@suse.de> <alpine.LNX.1.00.0806171428320.19665@iabervon.org>
 <20080617224856.GA16933@suse.de>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jun 2008, Greg KH wrote:

> On Tue, Jun 17, 2008 at 02:43:02PM -0400, Daniel Barkalow wrote:
> > 
> > On the other hand, it would be good if there were a way to include 
> > unstable APIs in the mainline kernel so that they could get some exposure 
> > before they're set in stone, and that would also eliminate that reason for 
> > keeping drivers out so long.
> 
> That's exactly what the documentation in Documentation/ABI is there for.
> Document your "experimental" API, along with any userspace programs that
> are using it, and work to try to finalize it.

Documentation/ABI/README doesn't list an "experimental" level of 
stability. I suppose a developer with an API they expect to change could 
create it as "obsolete" (since the experimental verison will get removed 
when the real one is done), but that's a little odd as a use of that 
category. Also, that doesn't stop people from looking through sysfs for 
useful stuff they expect to be undocumented but easy enough to figure out, 
and starting to use it without realizing that it's not intended to be 
maintained. And the "stable/syscalls" entry implies that all syscalls are 
stable when they get merged, which means that a patch that adds a syscall 
can't stablize in mainline.

If there are people, like the Nouveau developers, using the instability of 
their userspace API as a reason not to submit their drivers, and we would 
ideally like the drivers to stabilize with mainline exposure, then we need 
to do something more to address these authors' concerns.

	-Daniel
*This .sig left intentionally blank*
