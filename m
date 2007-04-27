Return-Path: <linux-kernel-owner+w=401wt.eu-S1755446AbXD0H2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbXD0H2K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 03:28:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755448AbXD0H2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 03:28:10 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44466 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755446AbXD0H2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 03:28:09 -0400
Date: Fri, 27 Apr 2007 00:27:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <ak@suse.de>, Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <clameter@engr.sgi.com>,
       "Martin J. Bligh" <mbligh@mbligh.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch -mm] oom: fix constraint deadlock
Message-Id: <20070427002730.0c67d90f.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704270018100.5200@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0704262243370.3461@chino.kir.corp.google.com>
	<20070427001228.e94ea60f.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704270018100.5200@chino.kir.corp.google.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007 00:19:43 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:

> On Fri, 27 Apr 2007, Andrew Morton wrote:
> 
> > > Subject: [patch -mm] oom: fix constraint deadlock
> > > Date: Thu, 26 Apr 2007 23:18:17 -0700 (PDT)
> > > 
> > > Fixes a deadlock in the OOM killer for allocations that are not
> > > __GFP_HARDWALL.
> > 
> > Thanks.
> > 
> > Why is this described as "patch -mm"?  It applies to mainline.  If it's
> > fixing a -mm patch, do you know which one?
> > 
> 
> Fair enough.  It definitely is applicable to mainline and fixes a deadlock 
> which we've been struggling with for awhile because not only does it block 
> while holding callback_mutex, but also tasklist_lock.

OK, thanks.  I tagged it for a 2.6.20.x backport as well.
