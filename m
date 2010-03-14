Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759467Ab0CNAPr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 19:15:47 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:39624 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759431Ab0CNAPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 19:15:44 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Dieter Ries <mail@dieterries.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH -tip 1/3] kprobes: Hide CONFIG_OPTPROBES and set if arch support optimized kprobes
References: <20100312232208.2017.55337.stgit@localhost6.localdomain6>
Date: Sun, 14 Mar 2010 09:15:35 +0900
In-Reply-To: <20100312232208.2017.55337.stgit@localhost6.localdomain6> (Masami
	Hiramatsu's message of "Fri, 12 Mar 2010 18:22:09 -0500")
Message-ID: <87k4tfyd08.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu <mhiramat@redhat.com> writes:

> Hide CONFIG_OPTPROBES and set if arch support optimized kprobes, since
> this option doesn't change the behavior of kprobes, but just reduces
> the overhead.

I don't so care whether this is configurable or not, but this confuses
me now. The following seems to say it's changed, but now this comment
says it wasn't changed. The following docs was obsoleted?

Thanks.

NOTE for geeks:
The jump optimization changes the kprobe's pre_handler behavior.
Without optimization, the pre_handler can change the kernel's execution
path by changing regs->ip and returning 1.  However, when the probe
is optimized, that modification is ignored.  Thus, if you want to
tweak the kernel's execution path, you need to suppress optimization,
using one of the following techniques:
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
