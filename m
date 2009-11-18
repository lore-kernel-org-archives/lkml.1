Return-Path: <linux-kernel-owner+w=401wt.eu-S1756485AbZKRDHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485AbZKRDHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 22:07:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753572AbZKRDHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 22:07:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752968AbZKRDHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 22:07:49 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip 0/3] tracepoint: Add signal events
In-Reply-To: Masami Hiramatsu's message of  Tuesday, 17 November 2009 18:41:17 -0500 <20091117234117.30589.61311.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091117234117.30589.61311.stgit@dhcp-100-2-132.bos.redhat.com>
X-Zippy-Says: Are we THERE yet?!
Message-Id: <20091118030706.EB93EA8C@magilla.sf.frob.com>
Date: Tue, 17 Nov 2009 19:07:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I would add the siginfo_t * argument to each of these tracepoints.

In 2/3 this comment:

+		/* Trace the actual delivered signals including SIG_IGN.*/

might be slightly misleading.  In most cases SIG_IGN signals won't make it
this far.  The same is true of SIG_DFL signals whose default action is to
ignore.  So one should be clear that trace_signal_deliver() is by no means
expected to get all SIG_IGN signals that are otherwise eligible for delivery.


Thanks,
Roland
