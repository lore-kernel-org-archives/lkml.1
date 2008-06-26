Return-Path: <linux-kernel-owner+w=401wt.eu-S1755982AbYFZApa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982AbYFZApa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 20:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754083AbYFZApN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 20:45:13 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:33697
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbYFZApL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 20:45:11 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 0 of 3] mmu notifier v18 for -mm
Message-Id: <patchbomb.1214440016@duo.random>
Date: Thu, 26 Jun 2008 02:26:56 +0200
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

Hello,

Christoph suggested me to repost v18 for merging in -mm, to give it more
exposure before the .27 merge window opens. There's no code change compared to
the previous v18 submission (the only change is the correction in the comment
in the mm_take_all_locks patch rightfully pointed out by Linus).

Full patchset including other XPMEM support patches can be found here:

	http://www.kernel.org/pub/linux/kernel/people/andrea/patches/v2.6/2.6.26-rc7/mmu-notifier-v18

Only the three patches of the patchset I'm submitting here by email are ready
for merging, the rest you can find in the website is not ready for merging yet
for various performance degradations, lots of the XPMEM patches needs to be
elaborated to avoid any slowdown for the non-XPMEM case, but I keep
maintaining them to make life easier to XPMEM current development and later we
can keep work on them to make them suitable for inclusion to avoid any
performance degradation risk.

(the fourth patch in the series of the above url, is not strictly relealted to
mmu notifiers but it's good at least for me to keep it in the same tree to
test pci-passthrough capable guest running on reserved-ram at the same time of
two regular guests swapping heavily with mmu notifiers which tends to
exercises both spte models at the same time, if you find this confusing I'll
remove it from any later upload, but xpmem users can totally ignore it, it
only touches x86-64 code)

Thanks a lot.
Andrea
