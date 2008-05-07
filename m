Return-Path: <linux-kernel-owner+w=401wt.eu-S1757368AbYEGWnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368AbYEGWnK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 18:43:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762025AbYEGWmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 18:42:40 -0400
Received: from relay1.sgi.com ([192.48.171.29]:40819 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762793AbYEGWmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 18:42:36 -0400
Date: Wed, 7 May 2008 17:42:33 -0500
From: Jack Steiner <steiner@sgi.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Robin Holt <holt@sgi.com>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
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
Message-ID: <20080507224232.GA24600@sgi.com>
References: <6b384bb988786aa78ef0.1210170958@duo.random> <alpine.LFD.1.10.0805071349200.3024@woody.linux-foundation.org> <20080507212650.GA8276@duo.random>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080507212650.GA8276@duo.random>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And I don't see a problem in making the conversion from
> spinlock->rwsem only if CONFIG_XPMEM=y as I doubt XPMEM works on
> anything but ia64.
 
That is currently true but we are also working on XPMEM for x86_64.
The new XPMEM code should be posted within a few weeks.

--- jack
