Return-Path: <linux-kernel-owner+w=401wt.eu-S1030190AbXBLWZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030190AbXBLWZQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 17:25:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030194AbXBLWZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 17:25:16 -0500
Received: from one.firstfloor.org ([213.235.205.2]:60269 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030190AbXBLWZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 17:25:14 -0500
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: - rdmsr_on_cpu-wrmsr_on_cpu.patch removed from -mm tree
Date: Mon, 12 Feb 2007 23:24:44 +0100
User-Agent: KMail/1.9.5
Cc: davej@redhat.com, linux-kernel@vger.kernel.org, adobriyan@openvz.org
References: <200702082132.l18LWhl4027000@shell0.pdx.osdl.net> <200702111138.23253.ak@suse.de> <20070212140043.6586665c.akpm@linux-foundation.org>
In-Reply-To: <20070212140043.6586665c.akpm@linux-foundation.org>
Organization: -
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702122324.44611.andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 February 2007 23:00, Andrew Morton wrote:
> > On Sun, 11 Feb 2007 11:38:23 +0100 Andi Kleen <ak@suse.de> wrote:
> > On Sunday 11 February 2007 01:11, Dave Jones wrote:
> > > On Thu, Feb 08, 2007 at 01:32:43PM -0800, akpm@linux-foundation.org wrote:
> > >  > 
> > >  > The patch titled
> > >  >      rdmsr_on_cpu, wrmsr_on_cpu
> > >  > has been removed from the -mm tree.  Its filename was
> > >  >      rdmsr_on_cpu-wrmsr_on_cpu.patch
> > >  > 
> > >  > This patch was dropped because I've lost the plot on this thing
> > > 
> > > Alexey, send me the latest fixed up version of this, and I'll
> > > queue this up to save Andrew trying to sort it out.
> > 
> > I fixed it up to at least support x86-64 too
> > 
> 
> No you didn't ;) I still get a build error with i386 allmodconfig using
> your version.

That's not surprising because I didn't change anything on i386

> 
> I backed out x86_64-mm-msr-on-cpu.patch (again) and went with Alexey's
> second version (again).  It works fine.

I think I'll just drop the thing. Nuisance:gain seems to be out of order

-Andi

