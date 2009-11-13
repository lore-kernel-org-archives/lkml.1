Return-Path: <linux-kernel-owner+w=401wt.eu-S932568AbZKMXaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568AbZKMXaa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 18:30:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932414AbZKMXa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 18:30:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1159 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932405AbZKMXa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 18:30:27 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/linus
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH -tip 1/3] Pass mm->flags to binfmt core_dump for bitflag
 consistency
In-Reply-To: Ingo Molnar's message of  Saturday, 14 November 2009 00:23:07 +0100 <20091113232307.GB21666@elte.hu>
References: <20091113225226.15079.90813.stgit@harusame>
	<20091113231602.2DD2C100E@magilla.sf.frob.com>
	<20091113232307.GB21666@elte.hu>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20091113232959.EF2F9100E@magilla.sf.frob.com>
Date: Fri, 13 Nov 2009 15:29:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> this would fix the (probably harmless) race too, but isnt the whole 
> approach taken by the patch more robust, i.e. to take a snapshot of 
> mm->flags value and pass it along coredump processing?

Yes, I think it is a fine thing to do.  I'm just being explicit about what
I think the (only) concrete issues are motivating a change.

> we should probably introduce a coredump parameter struct, and pass that 
> along:

Also sounds fine to me.


Thanks,
Roland
