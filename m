Return-Path: <linux-kernel-owner+w=401wt.eu-S1755683AbZFVUTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683AbZFVUTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 16:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752152AbZFVUTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 16:19:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33242 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbZFVUTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 16:19:17 -0400
Date: Mon, 22 Jun 2009 19:04:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Ratan Nalumasu <rnalumasu@gmail.com>,
       Roland McGrath <roland@redhat.com>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: [RFC,PATCH 0/2] do_wait() wakeup optimization
Message-ID: <20090622170432.GA4895@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have struct wait_opts, it is easy to solve the problems with
unnecessary wakeups from __wake_up_parent(). See the previous discussion

	"+ do_wait-wakeup-optimization.patch added to -mm tree"
	http://marc.info/?t=122729873300001

However, this complicates the code a bit and adds bytes 112 to compiled
code.

Ratan, Roland, do you think this optimisation is worthwhile?

Oleg.

