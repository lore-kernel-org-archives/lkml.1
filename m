Return-Path: <linux-kernel-owner+w=401wt.eu-S1761335AbYEGC3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761335AbYEGC3E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 22:29:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755488AbYEGC2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 22:28:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755109AbYEGC2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 22:28:50 -0400
Date: Tue, 6 May 2008 19:28:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Paul Menage" <menage@google.com>
Cc: "Paul Jackson" <pj@sgi.com>, lizf@cn.fujitsu.com,
       seto.hidetoshi@jp.fujitsu.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix cpuset sched_relax_domain_level control file
Message-Id: <20080506192825.53272f35.akpm@linux-foundation.org>
In-Reply-To: <6599ad830805061915s2525e48fw369e7c1aff167a76@mail.gmail.com>
References: <48210101.1070205@google.com>
	<20080506183841.e1771032.akpm@linux-foundation.org>
	<482109E5.5050204@cn.fujitsu.com>
	<20080506204946.7754302d.pj@sgi.com>
	<6599ad830805061851n767ff7a1qc8cb850ec98ad60d@mail.gmail.com>
	<20080506205852.8adaa0a2.pj@sgi.com>
	<20080506190809.df1b9398.akpm@linux-foundation.org>
	<20080506211121.e82bb51a.pj@sgi.com>
	<6599ad830805061915s2525e48fw369e7c1aff167a76@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008 19:15:27 -0700 "Paul Menage" <menage@google.com> wrote:

> On Tue, May 6, 2008 at 7:11 PM, Paul Jackson <pj@sgi.com> wrote:
> > Andrew wrote:
> >  > Paul should drop sched-devel.
> >
> >  I hope that refers to Paul M.
> 
> I'm building against 2.6.26-rc1, and don't see those warnings (or any
> useful code at those lines). It's probably more fallout from the
> cpuset files changes?

It's the git-sched-devel changes in linux-next.  Seems they are unaware of
the update_flag() changes we made in mainline last week.

