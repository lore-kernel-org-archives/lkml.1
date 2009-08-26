Return-Path: <linux-kernel-owner+w=401wt.eu-S1753658AbZHZVFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658AbZHZVFn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 17:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbZHZVFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 17:05:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36246 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbZHZVFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 17:05:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [Bug #14012] latest git fried my x86_64 imac
Date: Wed, 26 Aug 2009 23:06:38 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera> <_yaHeGjHEzG.A.NXH.BtGlKB@chimera> <4A9481B9.3070607@gmail.com>
In-Reply-To: <4A9481B9.3070607@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200908262306.38464.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 August 2009, Justin P. Mattock wrote:
> Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.30.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14012
> > Subject		: latest git fried my x86_64 imac
> > Submitter	: Justin P. Mattock<justinmattock@gmail.com>
> > Date		: 2009-08-13 07:20 (13 days old)
> > References	: http://marc.info/?l=linux-kernel&m=125014080427090&w=4
> >
> >
> >
> >    
> if I revert this commit:
> af6af30c0fcd77e621638e53ef8b176bca8bd3b4
> I can get a normal bootup.

Hm, that's

commit af6af30c0fcd77e621638e53ef8b176bca8bd3b4
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Wed Aug 5 20:41:04 2009 +0200

    ftrace: Fix perf-tracepoint OOPS

I wonder what happens if you compile out ftrace?

> As for this  bug, it seems I'm the only
> hitting this. The system is a fresh LFS build
> x86_64.
> In regards to keeping this open
> not sure, I don't have a problem with closing this
> and taking the blame as something I did during my build
> of the system, then if this becomes more frequent
> then open a new bug.

OK, I'll close it for now.

Thanks,
Rafael
