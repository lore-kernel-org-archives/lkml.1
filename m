Return-Path: <linux-kernel-owner+w=401wt.eu-S1761654AbYETKuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761654AbYETKuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 06:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbYETKua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 06:50:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:40274 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616AbYETKu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 06:50:29 -0400
Date: Tue, 20 May 2008 12:50:25 +0200
From: Nick Piggin <npiggin@suse.de>
To: Robin Holt <holt@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrea Arcangeli <andrea@qumranet.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <aliguori@us.ibm.com>, Chris Wright <chrisw@redhat.com>,
       Marcelo Tosatti <marcelo@kvack.org>, Eric Dumazet <dada1@cosmosbay.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [PATCH 08 of 11] anon-vma-rwsem
Message-ID: <20080520105025.GA25791@wotan.suse.de>
References: <20080513153238.GL19717@sgi.com> <20080514041122.GE24516@wotan.suse.de> <20080514112625.GY9878@sgi.com> <20080515075747.GA7177@wotan.suse.de> <Pine.LNX.4.64.0805151031250.18708@schroedinger.engr.sgi.com> <20080515235203.GB25305@wotan.suse.de> <20080516112306.GA4287@sgi.com> <20080516115005.GC4287@sgi.com> <20080520053145.GA19502@wotan.suse.de> <20080520100111.GC30341@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080520100111.GC30341@sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 05:01:11AM -0500, Robin Holt wrote:
> On Tue, May 20, 2008 at 07:31:46AM +0200, Nick Piggin wrote:
> > 
> > Really? You can get the information through via a sleeping messaging API,
> > but not a non-sleeping one? What is the difference from the hardware POV?
> 
> That was covered in the early very long discussion about 28 seconds.
> The read timeout for the BTE is 28 seconds and it automatically retried
> for certain failures.  In interrupt context, that is 56 seconds without
> any subsequent interrupts of that or lower priority.

I thought you said it would be possible to get the required invalidate
information without using the BTE. Couldn't you use XPMEM pages in
the kernel to read the data out of, if nothing else?
