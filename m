Return-Path: <linux-kernel-owner+w=401wt.eu-S1754895AbZKSTjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbZKSTjN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 14:39:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754465AbZKSTjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 14:39:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248AbZKSTjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 14:39:08 -0500
Date: Thu, 19 Nov 2009 14:38:15 -0500
From: Jason Baron <jbaron@redhat.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip v2 0/3] tracepoint: Add signal events
Message-ID: <20091119193814.GB2625@redhat.com>
References: <20091118211609.20207.55487.stgit@dhcp-100-2-132.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091118211609.20207.55487.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 04:16:09PM -0500, Masami Hiramatsu wrote:
> Hi,
> 
> These patches add signal related tracepoints including
> signal generation, delivery, and loss. First patch also
> moves signal-sending tracepoint from events/sched.h to
> events/signal.h.
> 
> Changes in v2
> - Add siginfo arguments
> 

hi Masami,

It would be really great if you could add docbook style comments to
your tracepoints. Here's the initial path I posted for the irq chapter:
http://lkml.indiana.edu/hypermail/linux/kernel/0904.3/02651.html

So you could add a new chapter for signals.

The current tracepoint docbook can be viewed at:

http://www.kernel.org/doc/htmldocs/tracepoint/

thanks,

-Jason
