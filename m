Return-Path: <linux-kernel-owner+w=401wt.eu-S1755780AbZESWZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780AbZESWZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 18:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752919AbZESWZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 18:25:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113AbZESWZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 18:25:50 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Jason Baron <jbaron@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@elte.hu,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org,
       jiayingz@google.com, mbligh@google.com, fche@redhat.com
Subject: Re: [PATCH 0/3] tracepoints: delay argument evaluation
In-Reply-To: Jason Baron's message of  Tuesday, 19 May 2009 18:16:26 -0400 <20090519221625.GA3205@redhat.com>
References: <cover.1242763826.git.jbaron@redhat.com>
	<20090519211704.GA3325@Krystal>
	<20090519221625.GA3205@redhat.com>
Emacs: more than just a Lisp interpreter, a text editor as well!
Message-Id: <20090519222504.AA0ECFC38D@magilla.sf.frob.com>
Date: Tue, 19 May 2009 15:25:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wasn't the plan to switch everything to the new TRACE_EVENT macro anyway?
That will be an API change to convert existing tracepoints.  Then the
various details of the actual call site code are easy to change inside that
new macro.


Thanks,
Roland
