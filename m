Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190Ab0BXVhd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 16:37:33 -0500
Received: from relay2.sgi.com ([192.48.179.30]:45293 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758180Ab0BXVhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 16:37:32 -0500
Date: Wed, 24 Feb 2010 15:37:29 -0600
From: Jack Steiner <steiner@sgi.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Panic in reserve_memtype()
Message-ID: <20100224213729.GA15936@sgi.com>
References: <20100224202258.GA615@sgi.com> <1267045764.16916.920.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267045764.16916.920.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 01:09:24PM -0800, Pallipadi, Venkatesh wrote:
> 
> On Wed, 2010-02-24 at 12:22 -0800, Jack Steiner wrote:
> > We see an X86_64 regression that started a few days ago. The kernel is booted
> > via EFI & panics in the pat.c code trying to deref a NULL pointer.
> > 
> > I didn't debug the problem but am suspicious of
> > 	x86, pat: Migrate to rbtree only backend for pat memtype management  x86/pat
> > 		author	Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>	
> > 		Wed, 10 Feb 2010 23:26:07 +0000 (15:26 -0800)
> > 	committer	H. Peter Anvin <hpa@zytor.com>	
> > 		Thu, 18 Feb 2010 23:41:36 +0000 (15:41 -0800)
> > 
> > 
> > 
> > Has anyone seen this? If not, I can debug further....
> > 
> 
> 
> Haven't seen this on my test systems here, but I haven't tested with EFI
> boot either.
> 
> I assume this is repeatable, and you always see this panic. I am looking
> at the code right now. Can you rollback this particular patch and see
> whether it goes away?

The problem is very repeatible.

FWIW, we have a nightly regression test that builds/tests the x86 tree
everynight at 1 AM. The failure started on the morning of Feb 22.

The build on Feb 21 (& all of Feb before then) passed w/o errors.
I can't rule out other errors but I don't see anything else that changed.

The linux-next tree appears to have the same problem.



--- jack
