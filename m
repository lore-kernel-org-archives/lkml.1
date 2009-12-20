Return-Path: <linux-kernel-owner+w=401wt.eu-S1754879AbZLTNJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbZLTNJP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 08:09:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754595AbZLTNJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 08:09:14 -0500
Received: from fom01.emnet.dk ([89.249.14.84]:53671 "EHLO fom01.emnet.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754576AbZLTNJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 08:09:13 -0500
X-AuditID: 59f90e54-b7bd7ae000001243-6e-4b2e21f75e48
Subject: Re: x264 benchmarks BFS vs CFS
From: Kasper Sandberg <lkml@metanurb.dk>
To: Andres Freund <andres@anarazel.de>
Cc: Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       Jason Garrett-Glaser <darkshikari@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML Mailinglist <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1261311050.14314.67.camel@localhost>
References: <1261042383.14314.0.camel@localhost>
	 <1261195412.8240.153.camel@marge.simson.net>
	 <1261244163.14314.62.camel@localhost>
	 <200912200422.18314.andres@anarazel.de>
	 <1261311050.14314.67.camel@localhost>
Content-Type: text/plain
Date: Sun, 20 Dec 2009 14:09:07 +0100
Message-Id: <1261314547.14314.69.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAxIa7B4SGuw4EhrsOQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-20 at 13:10 +0100, Kasper Sandberg wrote:
> On Sun, 2009-12-20 at 04:22 +0100, Andres Freund wrote:
> > On Saturday 19 December 2009 18:36:03 Kasper Sandberg wrote:
> > > Try this on a dualcore or quadcore system, or ofcourse just set the<
> > > niceness accordingly...
> > Oh well. This is getting too much for a normally very silent and flame fearing 
> > reader. Didnt *you* just tell others to shut up about using any tunables for 
> > any application? And that you dont need any tunables for BFS?
oh and btw, the niceness is not really a tunable"
> 
> That was an entirely different case, have you even been following the
> thread?
> 
> OFCOURSE you're going to see slowdowns on a UP system if you have a cpu
> hog and then run something else, this is the only behavior possible, and
> bfs handles it in a fair way.
> 
> when i said we needed no tunables, that was for running a _SINGLE_
> application, and then measuring said applications performance. (where
> BFS indeed does beat CFS by a quite large margin)
> 
> and as for CFS, it SHOULD exhibit fair behavior anyway, isnt it called
> "completely FAIR scheduler" ? or is that just the marketing name?
> 
> 
> 
> > 
> > Andres
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

