Return-Path: <linux-kernel-owner+w=401wt.eu-S1755208AbZEGGvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbZEGGvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 02:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbZEGGvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 02:51:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36267 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041AbZEGGvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 02:51:09 -0400
Date: Thu, 7 May 2009 08:46:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] do_wait cleanupe (more to come)
Message-ID: <20090507064630.GA15847@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Slightly tested. Definitely this needs more testing, but since a) the
second patch was reviewed by Ingo and b) Andrew likes the buggy patches
very much, I am sending this series. At least I believe this all is
right "in general".

I was going to send more cleanups (siginfo/rusage filling), but it turns
out we race with Vitaly who has already started this work.

Vitaly, could you re-diff your (imho very nice) changes on top of this
series?

Oleg.

