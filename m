Return-Path: <linux-kernel-owner+w=401wt.eu-S1757351AbYGOW6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351AbYGOW6l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 18:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756399AbYGOW6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 18:58:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48336 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756320AbYGOW6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 18:58:15 -0400
Date: Tue, 15 Jul 2008 15:57:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jon Tollefson <kniht@linux.vnet.ibm.com>
Cc: npiggin@suse.de, adobriyan@gmail.com, penberg@cs.helsinki.fi,
       mpm@selenic.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [patch v2] powerpc: hugetlb pgtable cache access cleanup
Message-Id: <20080715155731.eec7073c.akpm@linux-foundation.org>
In-Reply-To: <487D2982.90109@linux.vnet.ibm.com>
References: <20080604112939.789444496@amd.local0.net>
	<20080604113113.648031825@amd.local0.net>
	<487B7F96.70305@linux.vnet.ibm.com>
	<20080714155659.b4fab697.akpm@linux-foundation.org>
	<487D2982.90109@linux.vnet.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2008 17:49:38 -0500
Jon Tollefson <kniht@linux.vnet.ibm.com> wrote:

> Andrew Morton wrote:
> > On Mon, 14 Jul 2008 11:32:22 -0500
> > Jon Tollefson <kniht@linux.vnet.ibm.com> wrote:
> >
> >   
> >> Cleaned up use of macro.  We now reference the pgtable_cache array directly instead of using a macro.
> >>     
> >
> > This clashes rather a lot with all the other hugetlb things which we
> > have queued.
> >
> >   
> oops.  new version below here should be based on mmotm.

Yup, thanks.

> 
> 
> Cleaned up use of macro.  We now reference the pgtable_cache array directly instead of using a macro.

I queued this after its prerequisites.  Once those prerequisites have
reached mainline I'll send this patch in to the powerpc maintainers for
processing.  Unless they ack it and ask me to merge it, which is the
least-hassle option.

