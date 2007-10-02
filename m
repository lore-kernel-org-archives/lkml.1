Return-Path: <linux-kernel-owner+w=401wt.eu-S1755547AbXJBHoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbXJBHoz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 03:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbXJBHos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 03:44:48 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39774 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751455AbXJBHor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 03:44:47 -0400
Date: Tue, 2 Oct 2007 00:43:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       mpm@selenic.com, "Huang, Ying" <ying.huang@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Lameter <clameter@sgi.com>, apw@shadowen.org,
       "Lee.Schermerhorn@hp.com" <Lee.Schermerhorn@hp.com>
Subject: Re: x86 patches was Re: -mm merge plans for 2.6.24
Message-Id: <20071002004324.be030b63.akpm@linux-foundation.org>
In-Reply-To: <20071002163624.74534e7f.kamezawa.hiroyu@jp.fujitsu.com>
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
	<p733awu6nva.fsf@bingen.suse.de>
	<20071001233225.88c67e8b.akpm@linux-foundation.org>
	<20071002070110.GA30490@one.firstfloor.org>
	<20071002001809.0a814d0b.akpm@linux-foundation.org>
	<20071002163624.74534e7f.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2007 16:36:24 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

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
> 

For what reason, please?
