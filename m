Return-Path: <linux-kernel-owner+w=401wt.eu-S1756669AbZCRPsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669AbZCRPsH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 11:48:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752968AbZCRPry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 11:47:54 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:51312 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbZCRPrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 11:47:53 -0400
Date: Wed, 18 Mar 2009 08:49:36 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: linux-next: Tree for March 16 (slob)
Message-Id: <20090318084936.63f5c5de.randy.dunlap@oracle.com>
In-Reply-To: <20090317092902.GA6477@elte.hu>
References: <20090316220609.6f4a884c.sfr@canb.auug.org.au>
	<49BE9B20.70808@oracle.com>
	<20090317111129.5bf04ae6.sfr@canb.auug.org.au>
	<20090317092902.GA6477@elte.hu>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010207.49C11789.016C:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Mar 2009 10:29:02 +0100 Ingo Molnar wrote:

> 
> * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > On Mon, 16 Mar 2009 11:32:00 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > >
> > > mm/slob.c:480: error: 'flags' undeclared (first use in this function)
> > > 
> > > pseudo-patch:
> > > 
> > > s/flags/gfp/
> > 
> > Caused by commit cf40bd16fdad42c053040bcd3988f5fdedbb6c57 ("lockdep:
> > annotate reclaim context (__GFP_NOFS)") from the tracing tree.
> > 
> > Now fixed in the tip tree.
> 
> Note this has been broken for a relatively long time and only 
> got fixed when i noticed that randconfig was not as random as it 
> was supposed to be. That's how it started triggering in 
> linux-next too i suspect.


linux-next of 20090318 still has this build error.
Is the fix in some branch that is not merged into linux-next?

Thanks,
---
~Randy
