Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbZBOTSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbZBOTSS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 14:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbZBOTSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 14:18:04 -0500
Received: from smtp-114-sunday.nerim.net ([62.4.16.114]:60168 "EHLO
	maiev.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752755AbZBOTSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 14:18:03 -0500
Date: Sun, 15 Feb 2009 20:18:00 +0100
From: Damien Wyart <damien.wyart@free.fr>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12650] Strange load average and ksoftirqd behavior with
	2.6.29-rc2-git1
Message-ID: <20090215191800.GA2350@localhost.localdomain>
References: <juADNmcceYF.A.mdD.Mr0lJB@chimera> <rjPbZ5GRJPO.A.1kE.ur0lJB@chimera> <20090215080941.GA2295@localhost.localdomain> <20090215090026.GA31147@elte.hu> <20090215095128.GA3234@localhost.localdomain> <20090215101351.GA23274@elte.hu> <20090215103445.GA2335@localhost.localdomain> <20090215110104.GB31351@elte.hu> <20090215180355.GA2273@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090215180355.GA2273@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Also, my guess is that if you boot via idle=poll, the symptoms go away.
> > This would strengthen the suspicion that it's scheduler-clock troubles.

> In fact, with idle=poll, the symptoms do not go away, they are much
> stronger: without it, ksotirqd have a few % of CPU in top output; with
> it, they have 20 or 30% and the global average is not far from 1.

Not true each time, in fact. Another try with this option gave same
symptoms as without it, not stronger. In any case, they never go away.

-- 
Damien
