Return-Path: <linux-kernel-owner+w=401wt.eu-S1762935AbXEPUcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762935AbXEPUcA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 16:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758770AbXEPUbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 16:31:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:17154 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756942AbXEPUbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 16:31:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=LRKN4eA1uHg6i1k33uuLABsM6g6f54GXijg4Ucjqqe4KGTByOjYUSoVqJUqu5iKcOR2RSRbhs41nj8HQBvZFlUVQZHc9PDIIdmM7J6EWE8WK6PaiNDW87VNTw/HX3FtckaQaqo4SnQvg02VDMjJ0cLJEJyZHMqj0qbOdlttskYE=
Message-ID: <464B6A2B.9020703@googlemail.com>
Date: Wed, 16 May 2007 22:31:39 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, xfs-masters@oss.sgi.com,
       David Chinner <dgc@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       "Cherwin R. Nooitmeer" <cherwin@gmail.com>,
       Christoph Lameter <clameter@sgi.com>, Dave Airlie <airlied@linux.ie>,
       linux-ide@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
       Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Oleg Nesterov <oleg@tv-sign.ru>,
       Alex Dubov <oakad@yahoo.com>, Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: [2/3] 2.6.22-rc1: known regressions v2
References: <464B6743.9000607@googlemail.com>
In-Reply-To: <464B6743.9000607@googlemail.com>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc1.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions



File systems

Subject    : 2.6.21-git10/11: files getting truncated on xfs
References : http://lkml.org/lkml/2007/5/9/410
Submitter  : Jeremy Fitzhardinge <jeremy@goop.org>
Handled-By : David Chinner <dgc@sgi.com>
Patch      : http://lkml.org/lkml/2007/5/12/93
Status     : patch was suggested



Memory management

Subject    : kernel BUG at include/linux/slub_def.h:88 kmalloc_index()
References : http://bugzilla.kernel.org/show_bug.cgi?id=8476
Submitter  : Cherwin R. Nooitmeer <cherwin@gmail.com>
Status     : Unknown



SATA/PATA

Subject    : libata crash on halt
References : http://marc.info/?l=linux-ide&m=117899827710565&w=2
Submitter  : Andrew Morton <akpm@linux-foundation.org>
Caused-By  : Tejun Heo <htejun@gmail.com>
             commit 920a4b1038e442700a1cfac77ea7e20bd615a2c3
Status     : problem is being debugged

Subject    : libata reset-seq merge broke sata_sil on sh
References : http://lkml.org/lkml/2007/5/10/63
Submitter  : Paul Mundt <lethal@linux-sh.org>
Handled-By : Tejun Heo <htejun@gmail.com>
Caused-By  : commit 4750def52cb2c21732dda9aa1d43a07db37b0186
Status     : problem is being debugged



Suspend

Subject    : Broken suspend on SMP with tifm
References : http://lkml.org/lkml/2007/5/13/161
Submitter  : Rafael J. Wysocki <rjw@sisk.pl>
Status     : patch was suggested



Regards,
Michal

--
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
