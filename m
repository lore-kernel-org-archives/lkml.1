Return-Path: <linux-kernel-owner+w=401wt.eu-S932875AbYEBAZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932875AbYEBAZt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 20:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754847AbYEBAZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 20:25:41 -0400
Received: from ool-603879e4.static.optonline.net ([96.56.121.228]:60857 "EHLO
	orac.ofobscurity.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754750AbYEBAZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 20:25:40 -0400
X-Greylist: delayed 1746 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 May 2008 20:25:40 EDT
Date: Thu, 1 May 2008 19:55:58 -0400
From: Chris Knadle <Chris.Knadle@coredump.us>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adrian Bunk <bunk@kernel.org>, venkatesh.pallipadi@intel.com,
       davem@davemloft.net, trini@kernel.crashing.org, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com
Subject: Re: huge gcc 4.1.{0,1} __weak problem
Message-ID: <20080501235558.GA20637@orac.ofobscurity.com>
Reply-To: alpine.LFD.1.10.0805011525460.5994@woody.linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2008, Linus Torvalds wrote:
> On Thu, 1 May 2008, Andrew Morton wrote:
> > > 
> > > I see only the following choices:
> > > - remove __weak and replace all current usages
> > > - move all __weak functions into own files, and ensure that also happens
> > >   for future usages
> > > - #error for gcc 4.1.{0,1}
> > 
> > Can we detect the {0,1}?  __GNUC_EVEN_MORE_MINOR__?
>
> It's __GNUC_PATCHLEVEL__, I believe.
>
> So yes, we can distinguish 4.1.2 (good, and very common) from 4.1.{0,1} 
> (bad, and rather uncommon).
> And yes, considering that 4.1.1 (and even more so 4.1.0) should be rare to 
> begin with, I think it's better to just not support it.
>
>			Linus

   Unfortunately Debian Stable (i.e. Etch), which is relatively popular for server 
use, is still using 4.1.1  :-(  (The current gcc package is gcc-4.1.1-21)

   I have not looked to see if Debian Stable's gcc-4.1.1-21 has been patched for 
the currently discussed __weak bug.

   -- Chris

Chris Knadle
Chris.Knadle@coredump.us
