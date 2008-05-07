Return-Path: <linux-kernel-owner+w=401wt.eu-S1757294AbYEGBES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294AbYEGBES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 21:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbYEGBEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 21:04:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48776 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751379AbYEGBEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 21:04:05 -0400
Date: Tue, 6 May 2008 18:03:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Paul Menage" <menage@google.com>
Cc: "Paul Jackson" <pj@sgi.com>, torvalds@linux-foundation.org,
       lizf@cn.fujitsu.com, "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>,
       "Hiroyuki KAMEZAWA" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Dimitri Sivanich" <sivanich@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 125/311] Cpuset hardwall flag: switch cpusets to use the
 bulk cgroup_add_files() API
Message-Id: <20080506180326.f2f69dea.akpm@linux-foundation.org>
In-Reply-To: <6599ad830805061726n33f69552k756e8754387e4b8c@mail.gmail.com>
References: <200804290800.m3T80QFs009131@imap1.linux-foundation.org>
	<6599ad830804290329heea3c5fu7395b1ef71a87881@mail.gmail.com>
	<20080429053804.6d083a7f.akpm@linux-foundation.org>
	<20080506192018.26c1e3b7.pj@sgi.com>
	<6599ad830805061726n33f69552k756e8754387e4b8c@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008 17:26:22 -0700 "Paul Menage" <menage@google.com> wrote:

> On Tue, May 6, 2008 at 5:20 PM, Paul Jackson <pj@sgi.com> wrote:
> >
> >  I definitely agree with the above observations of Paul M.  I suspect
> >  that the patch might be missing the lines needed to -remove- the
> >  FILE_SCHED_RELAX_DOMAIN_LEVEL cases from the old style
> >  cpuset_common_file_read and cpuset_common_file_write switches.
> 
> Yes, it is - but I didn't have a tree with the relevant bits in it to
> remove, as far as I could see.

This whole fiasco was caused by unexpected changes magically appearing in
mainline late in the merge window.  All very predictable.

> >
> >   2) I didn't see any replies from Paul M in response to
> >     Andrews above request to "send us any needed fixup later
> >     in the week".
> >
> >         ==> Paul M or akpm - Is this fixup in the pipeline?
> 
> Not yet - I was waiting for 2.6.26-rc1-mm1 to come out. But I can send
> one against 2.6.26-rc1 directly if that helps.

I'm still crunching on backlog.  A fix against mainline would be great,
thanks.

