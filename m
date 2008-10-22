Return-Path: <linux-kernel-owner+w=401wt.eu-S1757939AbYJVSNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939AbYJVSNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 14:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752468AbYJVSNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 14:13:01 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:53815 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbYJVSNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 14:13:00 -0400
Message-ID: <48FF6CE5.2030101@s5r6.in-berlin.de>
Date: Wed, 22 Oct 2008 20:11:49 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Alex Howells <alex@bytemark.co.uk>
CC: Greg KH <greg@kroah.com>, Alexandre Oliva <oliva@lsd.ic.unicamp.br>,
       "H. Peter Anvin" <hpa@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
References: <20081016153053.GJ5834@nostromo.devel.redhat.com> <20081016154726.GA6331@kroah.com> <20081016171626.GB22554@cs181140183.pp.htv.fi> <20081017040239.GB28188@kroah.com> <20081017103138.1ca68d17@lxorguk.ukuu.org.uk> <48F8C000.8030003@kernel.org> <20081017174226.GF2221@kroah.com> <48F98DE2.8030205@kernel.org> <ortzb89bak.fsf@oliva.athome.lsd.ic.unicamp.br> <48FCD421.2010208@bytemark.co.uk> <20081020202147.GA20788@kroah.com> <48FE32E2.5000601@bytemark.co.uk>
In-Reply-To: <48FE32E2.5000601@bytemark.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Howells wrote:
> So with regards to supported kernels, the following springs to mind:
> 
>    *  how long is kernel 2.6.xx supported?
>    *  is kernel 2.6.xx one of the "longer term" supported ones?
>    *  what are the requirements for a maintainer to push a
>       new release, a la 2.6.xx.yy? Is it based on time elapsed,
>       severity of any fixes included?
>    *  how do we define "support" in this context?
>       does it mean security problems discovered/fixed *after*
>       development focus has moved on to new stuff is backported?
>       does it mean [critical] bug fixes? regression fixes?

That's all quite simple to answer with a firm "depends".

  1. Remember, it's all volunteer work (by companies and individuals).

  2. Watch the release announcements and changelogs to learn about the
     lifetimes of -stable lines (they vary due to circumstances) and
     about what goes in into these lines.  There are also some bits in
     Documentation/stable_kernel_rules.txt.

Among else, it depends on volunteered manpower for patch verification
and even on sheer coincidence (somebody needs to be aware that an issue
is relevant to an active -stable line) whether a fix goes into -stable
or not.

Circumstances which lead to a -stable line remaining active for longer
than usual typically boil down to the motives of an individual developer
who picks up maintenance, like Adrian happened to do with 2.6.16.y and
plans to repeat with 2.6.27.y, or like Greg kept/ keeps 2.6.25.y active
alongside 2.6.26.y because it's directly useful to other work of his, AFAIU.

If you are interested in more structured release policies, you shouldn't
hesitate to have a look at vendor kernel lines.
-- 
Stefan Richter
-=====-==--- =-=- =-==-
http://arcgraph.de/sr/
