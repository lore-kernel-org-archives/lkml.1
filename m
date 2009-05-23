Return-Path: <linux-kernel-owner+w=401wt.eu-S1756834AbZEWPQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834AbZEWPQm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 11:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbZEWPQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 11:16:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43975 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbZEWPQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 11:16:35 -0400
Date: Sat, 23 May 2009 11:16:28 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Tom Zanussi <tzanussi@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ftrace: Add task_comm support for trace_event
Message-ID: <20090523151628.GA2642@infradead.org>
References: <4A14FDFE.2080402@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A14FDFE.2080402@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 21, 2009 at 03:08:46PM +0800, Zhaolei wrote:
>             <...>-2289  [000] 526276.724790: sched_switch: task bash:2289 [120] ==> sshd:2287 [120]

we should have a space after the colon.  Also wouldn't it be better
to place task->commit close to the pid in the output?

