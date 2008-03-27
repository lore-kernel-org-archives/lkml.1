Return-Path: <linux-kernel-owner+w=401wt.eu-S1759492AbYC0J67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759492AbYC0J67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 05:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbYC0J6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 05:58:49 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49868 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbYC0J6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 05:58:48 -0400
Date: Thu, 27 Mar 2008 19:03:23 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Paul Menage" <menage@google.com>
Cc: "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Pavel Emelianov" <xemul@openvz.org>, "Hugh Dickins" <hugh@veritas.com>,
       "Sudhir Kumar" <skumar@linux.vnet.ibm.com>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       "David Rientjes" <rientjes@google.com>
Subject: Re: [RFC][0/3] Virtual address space control for cgroups (v2)
Message-Id: <20080327190323.f55a73e9.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <6599ad830803261522p45a9daddi8100a0635c21cf7d@mail.gmail.com>
References: <20080326184954.9465.19379.sendpatchset@localhost.localdomain>
	<6599ad830803261522p45a9daddi8100a0635c21cf7d@mail.gmail.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2008 15:22:47 -0700
"Paul Menage" <menage@google.com> wrote:

> On Wed, Mar 26, 2008 at 11:49 AM, Balbir Singh
> <balbir@linux.vnet.ibm.com> wrote:
> >
> >  The changelog in each patchset documents what has changed in version 2.
> >  The most important one being that virtual address space accounting is
> >  now a config option.
> >
> >  Reviews, Comments?
> >
> 
> I'm still of the strong opinion that this belongs in a separate
> subsystem. (So some of these arguments will appear familiar, but are
> generally because they were unaddressed previously).
> 
> 
How about creating "rlimit controller" and expands rlimit to process groups ?
I think it's more straightforward to do this.

Thanks,
-Kame

