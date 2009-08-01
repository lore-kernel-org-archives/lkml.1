Return-Path: <linux-kernel-owner+w=401wt.eu-S1751277AbZHAXcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751277AbZHAXcU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 19:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750952AbZHAXcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 19:32:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbZHAXcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 19:32:19 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] introduce tracehook_finish_jctl() helper
In-Reply-To: Andrew Morton's message of  Wednesday, 29 July 2009 15:50:07 -0700 <20090729155007.f4f5a793.akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
References: <20090729020139.GA7381@redhat.com>
	<20090729155007.f4f5a793.akpm@linux-foundation.org>
X-Windows: some voids are better left unfilled.
Message-Id: <20090801233207.E1FEB4C7FF@magilla.sf.frob.com>
Date: Sat,  1 Aug 2009 16:32:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Confused.  This patch has no effect.

Indeed, the three patches changing do_signal_stop() have no immediate
material effect.  They all just clean up the code and prepare the hooks
that utrace (or something like it) needs to make tracing stops mesh well
with job control stops.  I'd thought it might be simpler for review to just
roll these three together and send you a single patch to replace
signals-tracehook_notify_jctl-change.patch; but Oleg decided to keep it
sliced smaller.


Thanks,
Roland
