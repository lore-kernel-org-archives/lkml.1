Return-Path: <linux-kernel-owner+w=401wt.eu-S1759566AbYEKVnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759566AbYEKVnD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 17:43:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062AbYEKVmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 17:42:54 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:40144 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343AbYEKVmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 17:42:53 -0400
Date: Mon, 12 May 2008 00:41:31 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Parag Warudkar <parag.warudkar@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Frans Pop <elendil@planet.nl>
Subject: Re: [Bug #10616] Horrendous Audio Stutter - current git
Message-ID: <20080511214131.GM1645@cs181133002.pp.htv.fi>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera> <88YBFoyd1CN.A.K6.1w1JIB@chimera> <82e4877d0805111428j3f73f436w1c6094c779f6110d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <82e4877d0805111428j3f73f436w1c6094c779f6110d@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 05:28:47PM -0400, Parag Warudkar wrote:
> On Sun, May 11, 2008 at 4:04 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.25.  Please verify if it still should be listed.
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10616
> > Subject         : Horrendous Audio Stutter - current git
> 
> Still present both in Linus tree and sched-devel - root cause is not
> yet well understood per Ingo.
> 
> Worked around by disabling GROUP_SCHED stuff by default (commit
> aac6abca858386438d9a7233c3471d2ecfa2f704 ).

What causes this regression?

Is this commit 018d6db4cb5bbdcd65424a16f2dcca692ed32ae4
(sched: re-do "sched: fix fair sleepers") that had already been reverted 
in 2.6.25 for causing such regressions or is this caused by a different 
commit?

> Parag

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

