Return-Path: <linux-kernel-owner+w=401wt.eu-S1753568AbZKNBt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbZKNBt1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 20:49:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753400AbZKNBtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 20:49:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753145AbZKNBtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 20:49:25 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/linus
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip 2/3] Add coredump tracepoint
In-Reply-To: Ingo Molnar's message of  Saturday, 14 November 2009 01:14:10 +0100 <20091114001410.GC24738@elte.hu>
References: <20091113225226.15079.90813.stgit@harusame>
	<20091113225233.15079.41600.stgit@harusame>
	<20091113233912.192A3100E@magilla.sf.frob.com>
	<20091114000234.GA24738@elte.hu>
	<20091114000627.48ED615E8@magilla.sf.frob.com>
	<20091114001410.GC24738@elte.hu>
X-Windows: power tools for power fools.
Message-Id: <20091114014912.811F815E8@magilla.sf.frob.com>
Date: Fri, 13 Nov 2009 17:49:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Some sort of flexible core dump server perhaps, driven by user-space 
> logic? (vastly more flexible than coredump-filter or coredump ulimits 
> are today)

Tracepoints are not a very good fit for that.  I think people working on
things like that use the corename=|command support.


Thanks,
Roland
