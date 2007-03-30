Return-Path: <linux-kernel-owner+w=401wt.eu-S1945890AbXC3Cpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945890AbXC3Cpb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 22:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945915AbXC3Cpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 22:45:31 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:45231 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945890AbXC3Cpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 22:45:30 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 29 Mar 2007 19:43:04 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Nick Piggin <npiggin@suse.de>
cc: Ingo Molnar <mingo@elte.hu>, Nikita Danilov <nikita@clusterfs.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ravikiran G Thirumalai <kiran@scalex86.org>
Subject: Re: [rfc][patch] queued spinlocks (i386)
In-Reply-To: <20070330015902.GC19407@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0703291942280.1199@alien.or.mcafeemobile.com>
References: <20070323100418.GA30740@elte.hu> <20070323103243.GE11577@wotan.suse.de>
 <17925.18904.820106.145029@gargle.gargle.HOWL> <20070324172959.GB542@elte.hu>
 <20070328064318.GA12508@wotan.suse.de> <Pine.LNX.4.64.0703281224030.21150@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0703281452130.21150@alien.or.mcafeemobile.com>
 <20070329013652.GB2390@wotan.suse.de> <20070329071611.GA24176@wotan.suse.de>
 <Pine.LNX.4.64.0703291723140.1199@alien.or.mcafeemobile.com>
 <20070330015902.GC19407@wotan.suse.de>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2007, Nick Piggin wrote:

> > I slightly modified it to use cycles:
> > 
> > http://www.xmailserver.org/qspins.c
> 
> Slightly more than slightly ;)
> 
> You want to have a delay _outside_ the critical section as well, for
> multi-thread tests, otherwise the releasing CPU often just retakes
> the lock (in the unqueued lock case). As I said, most kernel code
> should _not_ be dropping and retaking locks.

Yeah. ATM it mostly does double-takes.



- Davide


