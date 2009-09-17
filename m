Return-Path: <linux-kernel-owner+w=401wt.eu-S1759177AbZIQSk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759177AbZIQSk5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 14:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759116AbZIQSk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 14:40:57 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:49592 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759134AbZIQSk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 14:40:56 -0400
Date: Thu, 17 Sep 2009 14:38:08 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: Nick Piggin <npiggin@suse.de>
cc: Mel Gorman <mel@csn.ul.ie>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       heiko.carstens@de.ibm.com, mingo@elte.hu, sachinp@in.ibm.com
Subject: Re: [RFC/PATCH] SLQB: Mark the allocator as broken PowerPC and
 S390
In-Reply-To: <20090917182842.GS18404@wotan.suse.de>
Message-ID: <alpine.DEB.1.10.0909171437180.5220@V090114053VZO-1>
References: <1253083059.5478.1.camel@penberg-laptop> <20090917100841.GF13002@csn.ul.ie> <1253183365.4975.20.camel@penberg-laptop> <20090917105707.GA7205@csn.ul.ie> <1253186019.4975.32.camel@penberg-laptop> <20090917111828.GB7205@csn.ul.ie>
 <20090917114116.GL18404@wotan.suse.de> <20090917181831.GA714@csn.ul.ie> <20090917182842.GS18404@wotan.suse.de>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Sep 2009, Nick Piggin wrote:

> > This machine has two CPUs (0, 1) and two nodes with actual memory (2,3).
> > After applying a patch to kmem_cache_create, I see in the console
> >
> > MEL::Creating cache pgd_cache CPU 0 Node 0
> > MEL::Creating cache pmd_cache CPU 0 Node 0
> > MEL::Creating cache pid_namespace CPU 0 Node 0
> > MEL::Creating cache shmem_inode_cache CPU 0 Node 0
> > MEL::Creating cache scsi_data_buffer CPU 1 Node 0

So we have two nodes 2,3 nothing on node 0 and we are creating caches on
the node that does not exist? SLQB assumes node 0 is present?

