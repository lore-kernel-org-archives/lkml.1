Return-Path: <linux-kernel-owner+w=401wt.eu-S1762527AbXKMUlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762527AbXKMUlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 15:41:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760000AbXKMUlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 15:41:37 -0500
Received: from waste.org ([66.93.16.53]:46480 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759963AbXKMUlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 15:41:36 -0500
Date: Tue, 13 Nov 2007 14:40:59 -0600
From: Matt Mackall <mpm@selenic.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, SL Baur <steve@xemacs.org>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-am33-list@redhat.com
Subject: Re: [PATCH 1/6] Suppress A.OUT library support if !CONFIG_BINFMT_AOUT [try #5]
Message-ID: <20071113204059.GZ17536@waste.org>
References: <20071110181416.31dc2614.akpm@linux-foundation.org> <20071109153432.20803.69832.stgit@warthog.procyon.org.uk> <20071109153437.20803.55096.stgit@warthog.procyon.org.uk> <6214.1194881680@redhat.com> <20071112115353.227f35cb.akpm@linux-foundation.org> <ed10ee420711121450m5aec7c06vf4481ebad944d706@mail.gmail.com> <17306.1194909291@redhat.com> <18662.1194951451@redhat.com> <20071113031835.54d558f9.akpm@linux-foundation.org> <1194958006.8255.1.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1194958006.8255.1.camel@twins>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 01:46:46PM +0100, Peter Zijlstra wrote:
> 
> On Tue, 2007-11-13 at 03:18 -0800, Andrew Morton wrote:
> > On Tue, 13 Nov 2007 10:57:31 +0000 David Howells <dhowells@redhat.com> wrote:
> > 
> > > SL Baur <steve@xemacs.org> wrote:
> > > 
> > > > Please take the emacsism out of the file as it bothers Andrew and others.
> > > 
> > > I thought Andrew said it didn't bother him.  I assume he was curious.
> > > 
> > 
> > Well it's just one line - hardly a big deal.
> > 
> > However if that line was a good one then we should get organised and
> > annotate all Kbuild files in the tree and appoint you
> > kbuild-makefile-tag-maintainer.
> > 
> > And if it wasn't a good line then it shouldn't have been added.
> 
> IFF we're going to annotate files like this, then also add the magic
> incantation to make vim do the right thing :-)

How about we change its name to something more sensible instead? We
only need this hack because the file has a .asm extension. It is
entirely reasonable for an editor (or a person!) to conclude that a
file with a .asm extension contains assembly language.

-- 
Mathematics is the supreme nostalgia of our time.
