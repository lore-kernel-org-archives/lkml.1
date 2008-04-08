Return-Path: <linux-kernel-owner+w=401wt.eu-S1755879AbYDHRFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879AbYDHRFg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 13:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754242AbYDHRF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 13:05:29 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:50633
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227AbYDHRF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 13:05:29 -0400
Date: Tue, 8 Apr 2008 19:05:25 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Robin Holt <holt@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>, akpm@linux-foundation.org,
       Nick Piggin <npiggin@suse.de>, Steve Wise <swise@opengridcomputing.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Kanoj Sarcar <kanojsarcar@yahoo.com>, Roland Dreier <rdreier@cisco.com>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH 2 of 9] Core of mmu notifiers
Message-ID: <20080408170525.GN10133@duo.random>
References: <patchbomb.1207669443@duo.random> <baceb322b45ed4328065.1207669445@duo.random> <20080408162619.GP11364@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080408162619.GP11364@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2008 at 11:26:19AM -0500, Robin Holt wrote:
> This one does not build on ia64.  I get the following:

I think it's a common code compilation bug not related to my
patch. Can you test this?

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -10,6 +10,7 @@
 #include <linux/rbtree.h>
 #include <linux/rwsem.h>
 #include <linux/completion.h>
+#include <linux/cpumask.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
 

