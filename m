Return-Path: <linux-kernel-owner+w=401wt.eu-S1765223AbYEGR5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765223AbYEGR5d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 13:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755702AbYEGR5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 13:57:13 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:47435
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755886AbYEGR5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 13:57:10 -0400
Date: Wed, 7 May 2008 19:57:05 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Robin Holt <holt@sgi.com>, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <aliguori@us.ibm.com>, Chris Wright <chrisw@redhat.com>,
       Marcelo Tosatti <marcelo@kvack.org>, Eric Dumazet <dada1@cosmosbay.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [PATCH 03 of 11] invalidate_page outside PT lock
Message-ID: <20080507175705.GE18260@duo.random>
References: <patchbomb.1210170950@duo.random> <d60d200565abde6a8ed4.1210170953@duo.random> <20080507133943.3e76c899@bree.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080507133943.3e76c899@bree.surriel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 01:39:43PM -0400, Rik van Riel wrote:
> Would it be an idea to merge them into one, so the first patch
> introduces the right conventions directly?

The only reason this isn't merged into one, is that this requires
non obvious (not difficult though) to the core VM code. I wanted to
keep an obviously safe approach for 2.6.26. The other conventions are
only needed by XPMEM and XPMEM can't work without all other patches anyway.
