Return-Path: <linux-kernel-owner+w=401wt.eu-S2993046AbXDFSFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993046AbXDFSFM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 14:05:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993040AbXDFSFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 14:05:11 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46054 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934116AbXDFSFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 14:05:09 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Roland Dreier <rdreier@cisco.com>
Cc: Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@tv-sign.ru>,
       Robin Holt <holt@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
References: <20070405195118.GH22762@lnx-holt.americas.sgi.com>
	<Pine.LNX.4.64.0704051352370.6730@woody.linux-foundation.org>
	<46159987.6090006@redhat.com>
	<Pine.LNX.4.64.0704051825400.6730@woody.linux-foundation.org>
	<m1hcru9rki.fsf@ebiederm.dsl.xmission.com>
	<20070406104301.GB19755@lnx-holt.americas.sgi.com>
	<m1mz1l8qdr.fsf@ebiederm.dsl.xmission.com>
	<20070406163100.GA554@tv-sign.ru> <20070406173249.GA2517@elte.hu>
	<adaps6h767i.fsf@cisco.com>
Date: Fri, 06 Apr 2007 12:04:05 -0600
In-Reply-To: <adaps6h767i.fsf@cisco.com> (Roland Dreier's message of "Fri, 06
	Apr 2007 10:39:29 -0700")
Message-ID: <m16489752i.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier <rdreier@cisco.com> writes:

>  > no. Two _completely separate_ lists.
>  > 
>  > i.e. a to-be-reaped task will still be on the main list _too_. The main 
>  > list is for all the PID semantics rules. The reap-list is just for 
>  > wait4() processing. The two would be completely separate.
>
> I guess this means we add another list head to struct task_struct.
> Not that big a deal, but it does make me a little sad to think about
> task_struct getting even bigger....

signal_struct please.  It isn't that much better but still...

Eric
