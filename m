Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbXJBQkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbXJBQkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 12:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbXJBQk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 12:40:26 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:61391 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbXJBQkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 12:40:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oJENdwzdbcr41E/z7ogWl6ZXe+UnpW42/Rsi0196zzWO6IcYU74tzCJ3MnYDOgunPdwQV2t/1qpUNm72Bc2RPgph31fqAOwWrEp4WRL7tPCkjYEbIog2SNucgl4vjdAwJDcpUgbNS/T2vJ7xK1am3rbVM3+RKYSPnyXqXbwYWjg=
Message-ID: <29495f1d0710020940o1278aca5h14d5daf89eb554f3@mail.gmail.com>
Date: Tue, 2 Oct 2007 09:40:23 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: x86 patches was Re: -mm merge plans for 2.6.24
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       mpm@selenic.com, "Huang, Ying" <ying.huang@intel.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Christoph Lameter" <clameter@sgi.com>, apw@shadowen.org,
       "Lee.Schermerhorn@hp.com" <Lee.Schermerhorn@hp.com>
In-Reply-To: <20071002163624.74534e7f.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
	 <p733awu6nva.fsf@bingen.suse.de>
	 <20071001233225.88c67e8b.akpm@linux-foundation.org>
	 <20071002070110.GA30490@one.firstfloor.org>
	 <20071002001809.0a814d0b.akpm@linux-foundation.org>
	 <20071002163624.74534e7f.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/2/07, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Tue, 2 Oct 2007 00:18:09 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> > >
> > > > How come?  Memoryless node can and do occur in real-world machines.  Kernel
> > > > should support that?
> > >
> > > But a node is just defined by its memory?
> >
> > Don't think so.  A node is a lump of circuitry which can have zero or more
> > CPUs, IO and memory.
> >
> > It may initially have been conceived as a memory-only concept in the Linux
> > kernel, but that doesn't fully map onto reality (does it?)
> >
> > There was a real-world need for this, I think from the Fujitsu guys.  That
> > should be spelled out in the changelog but isn't.
>
> Yes, Fujitsu and HP guys really need this memory-less-node support.

Anton's post (http://marc.info/?l=linux-mm&m=118133042025995&w=2) (and
my subsequent reposts) may have helped prompt this full series, which
then was picked up and shown to be useful to other folks. NUMA systems
with memoryless nodes exist in the wild and Linux did not do the right
thing there. Admittedly, Anton's case is hugetlb-specific, but the fix
I've been proposing (and hope to repost soon) depends on Christoph's
patches, especially the THISNODE fix.

Thanks,
Nish
