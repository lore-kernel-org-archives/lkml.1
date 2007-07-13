Return-Path: <linux-kernel-owner+w=401wt.eu-S935224AbXGMTOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935224AbXGMTOp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 15:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758828AbXGMTOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 15:14:34 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48675 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757492AbXGMTOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 15:14:32 -0400
Date: Fri, 13 Jul 2007 12:12:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: cmm@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [EXT4 set 5][PATCH 1/1] expand inode i_extra_isize to support
 features in larger inode
Message-Id: <20070713121259.20066d5b.akpm@linux-foundation.org>
In-Reply-To: <1184333621.20032.85.camel@twins>
References: <1183275482.4010.133.camel@localhost.localdomain>
	<20070710163247.5c8bfa3f.akpm@linux-foundation.org>
	<20070713020529.1486491f.akpm@linux-foundation.org>
	<1184333621.20032.85.camel@twins>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2007 15:33:41 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, 2007-07-13 at 02:05 -0700, Andrew Morton wrote:
> 
> > Except lockdep doesn't know about journal_start(), which has ranking
> > requirements similar to a semaphore.  
> 
> Something like so?

Looks OK.

> Or can journal_stop() be done by a different task than the one that did
> journal_start()? - in which case nothing much can be done :-/

Yeah, journal_start() and journal_stop() are well-behaved.
 
> This seems to boot... albeit I did not push it hard.

I fear the consequences of this change :(

Oh well, please keep it alive, maybe beat on it a bit, resend it
later on?
