Return-Path: <linux-kernel-owner+w=401wt.eu-S1759509AbYG3JOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759509AbYG3JOp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 05:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760945AbYG3JOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 05:14:18 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:57608 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760200AbYG3JOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 05:14:16 -0400
Subject: Re: [patch 01/15] kmsg: Kernel message catalog macros.
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       Michael Holzheu <holzheu@de.ibm.com>
In-Reply-To: <20080730013059.4d411750.akpm@linux-foundation.org>
References: <20080728175355.734299984@de.ibm.com>
	 <20080728175511.023246676@de.ibm.com>
	 <20080730013059.4d411750.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: IBM Corporation
Date: Wed, 30 Jul 2008 11:13:41 +0200
Message-Id: <1217409221.11260.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-30 at 01:30 -0700, Andrew Morton wrote:
> On Mon, 28 Jul 2008 19:53:56 +0200 Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> Numerous people want a facility like this for other-than-s390 use. 
> Progress has been intermittent and appears to have stopped.  The
> apparently-dead mailing list is archived here:
> https://lists.linux-foundation.org/pipermail/lf_kernel_messages/.
> 
> I don't know what the future holds for that development effort, but the
> requirement won't go away.  So one day someone is going to go and yank
> your implementation out of arch/s390 and into generic code.
> 
> So I'd suggest that you start out that way.

Somehow I have hoped for an answer like that :-) The only thing that
we'd have to do is find a proper place for the kmsg header file,
include/linux/kmsg.h comes to mind. The kmsg-doc script can easily be
change to check for multiple documentation directories, I was thinking
about Documentation/kmsg/$ARCH for the architecture specific things and
Documentation/kmsg for the generic parts.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


