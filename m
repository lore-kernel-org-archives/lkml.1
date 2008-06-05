Return-Path: <linux-kernel-owner+w=401wt.eu-S1753447AbYFEPiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbYFEPiW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 11:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbYFEPiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 11:38:12 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:54866
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbYFEPiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 11:38:11 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 0 of 3] mmu notifier v18
Message-Id: <patchbomb.1212680167@duo.random>
Date: Thu, 05 Jun 2008 17:36:07 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Robin Holt <holt@sgi.com>, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, kvm@vger.kernel.org,
       Kanoj Sarcar <kanojsarcar@yahoo.com>, Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <aliguori@us.ibm.com>, Chris Wright <chrisw@redhat.com>,
       Marcelo Tosatti <marcelo@kvack.org>, Eric Dumazet <dada1@cosmosbay.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Izik Eidus <izike@qumranet.com>, Anthony Liguori <aliguori@us.ibm.com>,
       Rik van Riel <riel@redhat.com>
Cc: andrea@qumranet.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This splits the list.h changes in patch number 1, mm_take_all_locks patch 2,
and mmu-notifier-core becomes patch 3 as requested.

mm_take/drop_all_locks have been cleaned up as requested to move the bitflips
in proper methods outside the main vma loop.
