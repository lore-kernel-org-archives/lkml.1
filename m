Return-Path: <linux-kernel-owner+w=401wt.eu-S1755818AbZDFNpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818AbZDFNpk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 09:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755026AbZDFNpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 09:45:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49028 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754312AbZDFNp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 09:45:29 -0400
Date: Mon, 6 Apr 2009 15:42:41 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Izik Eidus <ieidus@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
       avi@redhat.com, chrisw@redhat.com, mtosatti@redhat.com,
       hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 0/4] ksm - dynamic page sharing driver for linux v2
Message-ID: <20090406134240.GK9137@random.random>
References: <1238855722-32606-1-git-send-email-ieidus@redhat.com> <200904061704.50052.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904061704.50052.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 06, 2009 at 05:04:49PM +1000, Nick Piggin wrote:
> They should use a shared memory segment, or MAP_ANONYMOUS|MAP_SHARED etc.
> Presumably they will probably want to control it to interleave it over
> all numa nodes and use hugepages for it. It would be very little work.

I thought it's the intermediate result of the computations that leads
to lots of equal data too, in which case ksm is the only way to share
it all.
