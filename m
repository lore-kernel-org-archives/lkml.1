Return-Path: <linux-kernel-owner+w=401wt.eu-S1757194AbYEGOiC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194AbYEGOiC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 10:38:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757094AbYEGOhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 10:37:42 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:59645
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756788AbYEGOhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 10:37:40 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 00 of 11] mmu notifier #v16
Message-Id: <patchbomb.1210170950@duo.random>
Date: Wed, 07 May 2008 16:35:50 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Robin Holt <holt@sgi.com>, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>,
       akpm@linux-foundation.org, Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <aliguori@us.ibm.com>, Chris Wright <chrisw@redhat.com>,
       Marcelo Tosatti <marcelo@kvack.org>, Eric Dumazet <dada1@cosmosbay.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

this is the last update of the mmu notifier patch.

Jack asked a __mmu_notifier_register to call under mmap_sem in write mode.

Here an update with that change plus allowing ->release not to be implemented
(two liner change to mmu_notifier.c).

The entire diff between v15 and v16 mmu-notifier-core was posted in separate
email.
