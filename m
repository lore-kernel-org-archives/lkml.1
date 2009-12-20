Return-Path: <linux-kernel-owner+w=401wt.eu-S1754631AbZLTMK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbZLTMK7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 07:10:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754533AbZLTMK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 07:10:57 -0500
Received: from fom01.emnet.dk ([89.249.14.84]:65480 "EHLO fom01.emnet.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754530AbZLTMKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 07:10:55 -0500
X-AuditID: 59f90e54-b7bd7ae000001243-70-4b2e144ef512
Subject: Re: x264 benchmarks BFS vs CFS
From: Kasper Sandberg <lkml@metanurb.dk>
To: Andres Freund <andres@anarazel.de>
Cc: Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       Jason Garrett-Glaser <darkshikari@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML Mailinglist <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <200912200422.18314.andres@anarazel.de>
References: <1261042383.14314.0.camel@localhost>
	 <1261195412.8240.153.camel@marge.simson.net>
	 <1261244163.14314.62.camel@localhost>
	 <200912200422.18314.andres@anarazel.de>
Content-Type: text/plain
Date: Sun, 20 Dec 2009 13:10:50 +0100
Message-Id: <1261311050.14314.67.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-20 at 04:22 +0100, Andres Freund wrote:
> On Saturday 19 December 2009 18:36:03 Kasper Sandberg wrote:
> > Try this on a dualcore or quadcore system, or ofcourse just set the<
> > niceness accordingly...
> Oh well. This is getting too much for a normally very silent and flame fearing 
> reader. Didnt *you* just tell others to shut up about using any tunables for 
> any application? And that you dont need any tunables for BFS?

That was an entirely different case, have you even been following the
thread?

OFCOURSE you're going to see slowdowns on a UP system if you have a cpu
hog and then run something else, this is the only behavior possible, and
bfs handles it in a fair way.

when i said we needed no tunables, that was for running a _SINGLE_
application, and then measuring said applications performance. (where
BFS indeed does beat CFS by a quite large margin)

and as for CFS, it SHOULD exhibit fair behavior anyway, isnt it called
"completely FAIR scheduler" ? or is that just the marketing name?



> 
> Andres

