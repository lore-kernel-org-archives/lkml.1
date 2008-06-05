Return-Path: <linux-kernel-owner+w=401wt.eu-S1759431AbYFEQSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759431AbYFEQSt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 12:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754265AbYFEQSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 12:18:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60201 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753591AbYFEQSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 12:18:39 -0400
Date: Thu, 5 Jun 2008 09:15:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Robin Holt <holt@sgi.com>, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, kvm@vger.kernel.org,
       Kanoj Sarcar <kanojsarcar@yahoo.com>, Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <aliguori@us.ibm.com>, Chris Wright <chrisw@redhat.com>,
       Marcelo Tosatti <marcelo@kvack.org>, Eric Dumazet <dada1@cosmosbay.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Izik Eidus <izike@qumranet.com>, Anthony Liguori <aliguori@us.ibm.com>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 2 of 3] mm_take_all_locks
In-Reply-To: <082f312bc6821733b1c3.1212680169@duo.random>
Message-ID: <alpine.LFD.1.10.0806050913060.3473@woody.linux-foundation.org>
References: <082f312bc6821733b1c3.1212680169@duo.random>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just a small comment fix.

On Thu, 5 Jun 2008, Andrea Arcangeli wrote:
> +		/*
> +		 * AS_MM_ALL_LOCKS can't change from under us because
> +		 * we hold the global_mm_spinlock.

There's no global_mm_spinlock, you mean the 'mm_all_locks_mutex'.

(There was at least one other case where you had that comment issue).

		Linus
