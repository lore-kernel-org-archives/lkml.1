Return-Path: <linux-kernel-owner+w=401wt.eu-S1760788AbXEKHmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760788AbXEKHmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 03:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755159AbXEKHmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 03:42:11 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47662 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755369AbXEKHmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 03:42:10 -0400
Date: Fri, 11 May 2007 00:42:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
Cc: Hugh Dickins <hugh@veritas.com>,
       William Lee Irwin III <wli@holomorphy.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: slub-i386-support.patch
Message-Id: <20070511004200.6d30152e.akpm@linux-foundation.org>
In-Reply-To: <20070511082930.GP2012@bingen.suse.de>
References: <Pine.LNX.4.64.0705102028550.25681@blonde.wat.veritas.com>
	<20070510203102.GO19966@holomorphy.com>
	<Pine.LNX.4.64.0705102349150.24200@blonde.wat.veritas.com>
	<20070511082930.GP2012@bingen.suse.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2007 10:29:30 +0200 Andi Kleen <ak@suse.de> wrote:

> > I'm guessing (haven't rechecked source) that the cpu_idle() call comes
> > about because the top level pgd of a process gets freed very late in
> > its exit, and after a great flurry of processes have just exited,
> > perhaps there was nothing to free up the accumulation.  Though
> > it still strikes me as an odd place to do it.
> 
> I always found it odd and probably the wrong place too.

so... what's the bottom line here, guys?  Should we change that patch?
