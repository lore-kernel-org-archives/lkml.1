Return-Path: <linux-kernel-owner+w=401wt.eu-S932137AbYDVU0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137AbYDVU0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 16:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755864AbYDVU0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 16:26:15 -0400
Received: from relay1.sgi.com ([192.48.171.29]:49185 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754553AbYDVU0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 16:26:13 -0400
Date: Tue, 22 Apr 2008 13:26:13 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Nick Piggin <npiggin@suse.de>, Jack Steiner <steiner@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       Robin Holt <holt@sgi.com>, general@lists.openfabrics.org,
       Hugh Dickins <hugh@veritas.com>, akpm@linux-foundation.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 10 of 12] Convert mm_lock to use semaphores after
 i_mmap_lock and anon_vma_lock
In-Reply-To: <f8210c45f1c6f8b38d15.1208872286@duo.random>
Message-ID: <Pine.LNX.4.64.0804221325490.3640@schroedinger.engr.sgi.com>
References: <f8210c45f1c6f8b38d15.1208872286@duo.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doing the right patch ordering would have avoided this patch and allow 
better review.


