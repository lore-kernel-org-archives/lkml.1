Return-Path: <linux-kernel-owner+w=401wt.eu-S1945961AbXBIAzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945961AbXBIAzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 19:55:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945960AbXBIAzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 19:55:47 -0500
Received: from ozlabs.org ([203.10.76.45]:43769 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945961AbXBIAzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 19:55:46 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17867.50828.463593.134082@cargo.ozlabs.ibm.com>
Date: Fri, 9 Feb 2007 11:55:40 +1100
From: Paul Mackerras <paulus@samba.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>, linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.21
In-Reply-To: <20070208155300.9347e0cb.akpm@linux-foundation.org>
References: <20070208150710.1324f6b4.akpm@linux-foundation.org>
	<20070208233449.GC18899@athena.road.mcmartin.ca>
	<20070208155300.9347e0cb.akpm@linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton writes:

> Once a subsystem has a subsystem tree (git or quilt) I basically never
> merge anything which belongs to that tree.  It's always
> 
> 	originator->mm->subsystemtree->Linus
> 
> If the subsystem tree maintainer wants to tell me "I can't be bothered
> setting up a git pull for that, please merge it for me" then that's fine.
> 
> But unless I'm told that, or unless the maintainer is vacationing or totally
> asleep or unless the fix has some sufficiently high obviousness*importance product,
> I'll just keep buffering it up.  

What about the sort of thing that crosses all archs?  For example, the
local_t changes?  Particularly in the case where the change has to be
made in generic code and in all archs at the same time, it makes sense
to me for you to send the whole batch to Linus at the same time,
rather than individual arch maintainers all sending their bit at
varying times.

Paul.
