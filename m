Return-Path: <linux-kernel-owner+w=401wt.eu-S1764988AbYEGRlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764988AbYEGRlz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 13:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763639AbYEGRlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 13:41:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763047AbYEGRlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 13:41:08 -0400
Date: Wed, 7 May 2008 13:39:43 -0400
From: Rik van Riel <riel@redhat.com>
To: Andrea Arcangeli <andrea@qumranet.com>
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
Message-ID: <20080507133943.3e76c899@bree.surriel.com>
In-Reply-To: <d60d200565abde6a8ed4.1210170953@duo.random>
References: <patchbomb.1210170950@duo.random>
	<d60d200565abde6a8ed4.1210170953@duo.random>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 May 2008 16:35:53 +0200
Andrea Arcangeli <andrea@qumranet.com> wrote:

> # HG changeset patch
> # User Andrea Arcangeli <andrea@qumranet.com>
> # Date 1210115129 -7200
> # Node ID d60d200565abde6a8ed45271e53cde9c5c75b426
> # Parent  c5badbefeee07518d9d1acca13e94c981420317c
> invalidate_page outside PT lock
> 
> Moves all mmu notifier methods outside the PT lock (first and not last
> step to make them sleep capable).

This patch appears to undo some of the changes made by patch 01/11.

Would it be an idea to merge them into one, so the first patch
introduces the right conventions directly?

-- 
All rights reversed.
