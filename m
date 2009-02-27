Return-Path: <linux-kernel-owner+w=401wt.eu-S1758221AbZB0HH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221AbZB0HH0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 02:07:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476AbZB0HHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 02:07:12 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36438 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321AbZB0HHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 02:07:10 -0500
Date: Fri, 27 Feb 2009 16:05:50 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       kenchen@google.com, "menage@google.com" <menage@google.com>,
       mingo@elte.hu, "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH] change cpuacct usage percpu format
Message-Id: <20090227160550.9f6484b6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <49A79059.4080804@cn.fujitsu.com>
References: <20090227140537.390905c4.kamezawa.hiroyu@jp.fujitsu.com>
	<20090227063955.GS11421@balbir.in.ibm.com>
	<20090227155517.9283641b.kamezawa.hiroyu@jp.fujitsu.com>
	<20090227070148.GU11421@balbir.in.ibm.com>
	<49A79059.4080804@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Feb 2009 15:03:53 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> >> Hmm, like this ?
> >> ==
> >> seq_printf(m, "%d: %llu\n", i, (unsigned long long) percpu);
> >> or
> >> seq_printf(m, "%d\t: %llu\n", i, (unsigned long long) percpu);
> >> ==
> >>
> >>
> > 
> > I'd like to see : and not space after it so something like
> > 
> > seq_printf(m, "%d:%llu\n", i, (unsigned long long) percpu);
> 
> I vote for this. :)
> 
ok, I'll take that and prepare new patch.

Regards,
-Kame

