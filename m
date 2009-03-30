Return-Path: <linux-kernel-owner+w=401wt.eu-S1755350AbZC3Veg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbZC3Veg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 17:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757076AbZC3VeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 17:34:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:48580 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755466AbZC3VeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 17:34:05 -0400
Subject: Re: [PATCH] make inotify event handles use GFP_NOFS
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, balbir@linux.vnet.ibm.com, linux-fsdevel@vger.kernel.org,
       aviro@redhat.com
In-Reply-To: <20090330142610.4b94935d.akpm@linux-foundation.org>
References: <1237400852.26799.16.camel@localhost.localdomain>
	 <20090330142610.4b94935d.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 30 Mar 2009 23:33:36 +0200
Message-Id: <1238448816.4073.265.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-30 at 14:26 -0700, Andrew Morton wrote:
> On Wed, 18 Mar 2009 14:27:32 -0400
> Eric Paris <eparis@redhat.com> wrote:
> 
> > I think this is a bandaide to shut up lockdep.  I could either figure
> > out lockdep classes and figure out how to reclassify inotify locks since
> > I believe Nick is correct when he says inotify watches pin the inode in
> > core so memory pressure can't evict it.
> 
> It's pretty sad to degrading the strength of the memory allocation just
> to squish a lockdep report.

Yeah, I agree, its the wrong thing to do. lockdep annotations really
aren't that hard -- also, you could also talk me through it.

