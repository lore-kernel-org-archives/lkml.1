Return-Path: <linux-kernel-owner+w=401wt.eu-S1755962AbZLCKkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962AbZLCKkD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 05:40:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755947AbZLCKkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 05:40:03 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48616 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755941AbZLCKkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 05:40:01 -0500
Date: Thu, 3 Dec 2009 11:39:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
       Jason Baron <jbaron@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH v2] [RFC] tracepoint: Add signal coredump tracepoint
Message-ID: <20091203103935.GA7628@elte.hu>
References: <4B128ECF.9020906@redhat.com>
 <20091202204637.25408.41195.stgit@dhcp-100-2-132.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091202204637.25408.41195.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Add signal coredump tracepoint which shows signal number, mm->flags, 
> limits, pointer to file structure and core file name.

Why is the kernel pointer to the file structure logged? User-space has 
no use for it and the analysis value is low.

	Ingo
