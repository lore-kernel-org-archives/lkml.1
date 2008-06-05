Return-Path: <linux-kernel-owner+w=401wt.eu-S1757715AbYFEVah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715AbYFEVah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 17:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbYFEVa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 17:30:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47366 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751509AbYFEVa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 17:30:27 -0400
Date: Thu, 5 Jun 2008 14:29:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ian Kent <raven@themaw.net>
cc: Al Viro <viro@ZenIV.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>,
       jesper@krogh.cc, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux 2.6.26-rc4
In-Reply-To: <1212651099.3047.44.camel@raven.themaw.net>
Message-ID: <alpine.LFD.1.10.0806051427310.3473@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org>  <47107.195.41.66.226.1212486572.squirrel@mail.jabbernet.dk>  <20080603095713.GR28946@ZenIV.linux.org.uk>  <5440.195.41.66.226.1212487482.squirrel@mail.jabbernet.dk> 
 <E1K3TWc-0005gV-1l@pomaz-ex.szeredi.hu>  <20080603104035.GT28946@ZenIV.linux.org.uk>  <E1K3U1F-0005le-07@pomaz-ex.szeredi.hu>  <20080603105258.GV28946@ZenIV.linux.org.uk>  <1212499623.3025.46.camel@raven.themaw.net>  <alpine.LFD.1.10.0806030751040.3473@woody.linux-foundation.org>
 <1212651099.3047.44.camel@raven.themaw.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 5 Jun 2008, Ian Kent wrote:
> 
> Keep in mind this doesn't address any other autofs4 issues but I it
> should allow us to identify if this was in fact the root cause of the
> problem Jesper reported.

Jesper, can you test this? I think you said you could trigger this in ~24 
hours or so? I'd love to have some testing of some heavy autofs user. Even 
if it's not a guarantee of a fix (due to reproducing the bug not being 
entirely trivial), at least I'd like to know that it doesn't introduce any 
obvious new problems either..

			Linus
