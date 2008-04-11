Return-Path: <linux-kernel-owner+w=401wt.eu-S1760120AbYDKKec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760120AbYDKKec (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 06:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758949AbYDKKeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 06:34:22 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:39740 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758229AbYDKKeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 06:34:21 -0400
Subject: Re: 2.6.25-rc8-mm2
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>
In-Reply-To: <20080411192346.6872472a.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080410203354.f0a6f464.akpm@linux-foundation.org>
	 <20080411185703.a5407940.kamezawa.hiroyu@jp.fujitsu.com>
	 <20080411192346.6872472a.kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 11 Apr 2008 13:34:18 +0300
Message-Id: <1207910058.7212.1.camel@haji>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.12.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-11 at 19:23 +0900, KAMEZAWA Hiroyuki wrote:
> On Fri, 11 Apr 2008 18:57:03 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > On Thu, 10 Apr 2008 20:33:54 -0700
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > 
> > >
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc8/2.6.25-rc8-mm2/
> > > 
> > > - Compilation is busted on mips due to the page-flags patches
> > > 
> > On ia64/NUMA box (which has empty nodes.)
> > 
> > CONFIG_SLAB ..... booted well
> > CONFIG_SLUB ..... can't boot
> > CONFIG_SLUB + CONFIG_SLUB_DEBUG_ON .... booted. Hmm?
> > 
> > I'll dig more if I can.
> > 
> with slub_nomerge , booted.

What happens when it doesn't boot? Does it hang or do you get an oops?
Can you reproduce it with the 'for-mm' branch of:

 git://git.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git

			Pekka

