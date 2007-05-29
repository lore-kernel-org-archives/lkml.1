Return-Path: <linux-kernel-owner+w=401wt.eu-S1757183AbXE2Mys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183AbXE2Mys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 08:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbXE2MyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 08:54:00 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:37005 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbXE2Mx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 08:53:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=Ur78h8LYkIxujWEla9SRpLrhCGbxGSnzjuHX95K/OLP6HGwso6Vj6qf6fx+yNMsYJilMAmlxY8JBppEsnVoYTK4ZlDGF8saH/hMwTPdBcwKtVEdPoTMCRxRhM7YC7nCTEG/TKu7+WHx5KieklS+6yHT00FVabxG5dpUyfqg2UHk=
Message-ID: <465C225C.7090507@googlemail.com>
Date: Tue, 29 May 2007 14:53:48 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Maximilian Engelhardt <maxi@daemonizer.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, zach@vmware.com,
       =?ISO-8859-2?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>,
       Alexey Dobriyan <adobriyan@gmail.com>, Andi Kleen <ak@suse.de>,
       discuss@x86-64.org, Jeff Garzik <jeff@garzik.org>,
       Ben Collins <ben.collins@ubuntu.com>
Subject: Re: [3/3] 2.6.22-rc3: known regressions with patches
References: <465C203A.1020200@googlemail.com>
In-Reply-To: <465C203A.1020200@googlemail.com>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc3
with patches available.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions



Suspend

Subject    : software suspend doesn't work with 2.6.22-rc3
References : http://lkml.org/lkml/2007/5/26/24
Submitter  : Maximilian Engelhardt <maxi@daemonizer.de>
Handled-By : Rafael J. Wysocki <rjw@sisk.pl>
Patch      : http://lkml.org/lkml/2007/5/26/169
Status     : patch available



TTY

Subject    : signal: multithread program returns with wrong errno on receiving SIGSTOP
References : http://lkml.org/lkml/2007/5/27/189
Submitter  : Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Handled-By : Oleg Nesterov <oleg@tv-sign.ru>
Patch      : http://lkml.org/lkml/2007/5/28/27
Status     : patch available



Virtualization

Subject    : build failed in arch/i386/kernel/vmi.c
References : http://lkml.org/lkml/2007/5/24/119
Submitter  : Toralf Förster <toralf.foerster@gmx.de>
Handled-By : Alexey Dobriyan <adobriyan@gmail.com>
Patch      : http://lkml.org/lkml/2007/5/24/143
Status     : patch available



x86-64

Subject    : BUG: at mm/slab.c:777 __find_general_cachep()
References : http://lkml.org/lkml/2007/5/18/17
Submitter  : Jeff Garzik <jeff@garzik.org>
Handled-By : Ben Collins <ben.collins@ubuntu.com>
Patch      : http://lkml.org/lkml/2007/5/18/19
Status     : patch available



Regards,
Michal

--
"Najbardziej brakowa³o mi twojego milczenia."
-- Andrzej Sapkowski "Co¶ wiêcej"

