Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873Ab0AFOcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873Ab0AFOcY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 09:32:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755842Ab0AFOcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 09:32:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755715Ab0AFOcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 09:32:22 -0500
Message-ID: <4B449F38.8020803@redhat.com>
Date: Wed, 06 Jan 2010 09:33:28 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Masami Hiramatsu <mhiramat@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH -tip 8/8] perf probe: Support --line option to show probable
 source-code lines
References: <20100105224634.19431.3259.stgit@dhcp-100-2-132.bos.redhat.com> <20100105224730.19431.55102.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20100105224730.19431.55102.stgit@dhcp-100-2-132.bos.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
> Add --line option to support showing probable source-code lines.
> 
> perf probe --line SRC:LN[-LN|+NUM]
>  or
> perf probe --line FUNC[:LN[-LN|+NUM]]
> 
> This option shows source-code with line number if the line can be
> probed. Lines without line number (and blue color) means that the
> line can not be probed, because debuginfo doesn't have the
> information of those lines.
> 
> The argument specifies the range of lines, "source.c:100-120" shows
> lines between 100th to l20th in source.c file. And "func:10+20"
> shows 20 lines from 10th line of func function.

Oops, I found this will conflict with Arnaldo's patch.
I'll update this on his patches.

Thank you,
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

