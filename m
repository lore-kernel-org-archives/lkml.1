Return-Path: <linux-kernel-owner+w=401wt.eu-S933915AbXJTGAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933915AbXJTGAU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 02:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758741AbXJTGAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 02:00:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752871AbXJTGAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 02:00:07 -0400
Date: Sat, 20 Oct 2007 01:54:45 -0400
From: Rik van Riel <riel@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ian Kent <raven@themaw.net>, Christoph Hellwig <hch@lst.de>,
       Dave Hansen <haveblue@us.ibm.com>
Subject: Re: 2.6.23-mm1 - autofs broken
Message-ID: <20071020015445.0c0dcda6@bree.surriel.com>
In-Reply-To: <20071020015404.437b6937@bree.surriel.com>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
	<20071020011310.30abc16b@bree.surriel.com>
	<20071019223900.edd04f65.akpm@linux-foundation.org>
	<20071020015404.437b6937@bree.surriel.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Oct 2007 01:54:04 -0400
Rik van Riel <riel@redhat.com> wrote:

> On Fri, 19 Oct 2007 22:39:00 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Sat, 20 Oct 2007 01:13:10 -0400 Rik van Riel <riel@redhat.com>
> > wrote:
> > 
> > > On Thu, 11 Oct 2007 21:31:26 -0700
> > > Andrew Morton <akpm@linux-foundation.org> wrote:
> > > 
> > > > 
> > > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23/2.6.23-mm1/
> > > > 
> > > > - I've been largely avoiding applying anything since rc8-mm2 in
> > > > an attempt to stabilise things for the 2.6.23 merge.
> > > 
> > > Between rc8-mm2 and 2.6.23-mm1, autofs stopped working in the
> > > -mm kernel.
> > > 
> > > Instead of mounting my home directory, I get these messages in
> > > /var/log/messages:
> > > 
> > > Oct 20 00:38:52 kenny automount[2293]: cache_readlock: mapent
> > > cache rwlock lock failed
> > > Oct 20 00:38:52 kenny automount[2293]: unexpected pthreads error:
> > > 11 at 65 in cache.c
> > > 
> > > I am not sure if this is due to autofs changes or changes in some
> > > other code that was merged.  If you can think of any suspicious
> > > change that I should test, please let me know.
> > 
> > I don't think anything changed in autofs in that period.  I'd be
> > suspecting the r-o-bind-mounts patches, but they didn't change much
> > in that time either.
> > 
> > Does current mainline work OK?  If so, pretty much the only thing in
> > that area left unmerged is r-o-bind-mounts and hch's exportfs stuff.
> 
> Yes, 2.6.23 mainline works fine.

Let me clarify: 2.6.23 vanilla works.

I have not yet tried the latest 2.6.23+ git tree.

-- 
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan
