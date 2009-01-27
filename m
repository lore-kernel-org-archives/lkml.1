Return-Path: <linux-kernel-owner+w=401wt.eu-S1754060AbZA0V4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbZA0V4F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 16:56:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755933AbZA0Vzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 16:55:49 -0500
Received: from kandzendo.ru ([195.178.208.66]:43731 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756227AbZA0Vzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 16:55:48 -0500
Date: Wed, 28 Jan 2009 00:55:39 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, balbir@linux.vnet.ibm.com,
       Nikanth Karthikesan <knikanth@suse.de>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Torvalds <torvalds@linux-foundation.org>,
       Arve Hj?nnev?g <arve@android.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, Paul Menage <menage@google.com>
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
Message-ID: <20090127215539.GC12431@ioremap.net>
References: <alpine.DEB.2.00.0901262350110.14525@chino.kir.corp.google.com> <20090127093105.GB2646@ioremap.net> <20090127193058.D48B.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090127134559.GB18119@ioremap.net> <alpine.DEB.2.00.0901271238090.21124@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0901271238090.21124@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 12:41:03PM -0800, David Rientjes (rientjes@google.com) wrote:
> > Having some special application which will monitor /dev/mem_notify and
> > kill processes based on its own hueristics is a good idea, but when it
> > fails to do its work (or does not exist) system has to have ability to
> > make a progress and invoke a main oom-killer.
> 
> Agreed, very similiar to the cgroup oom notifier patch that invokes the 
> oom killer if there are no attached tasks waiting to handle the situation. 
> 
> In this case, it would be a configurable delay to allow userspace to act 
> in response to oom conditions before invoking the kernel oom killer.  So 
> instead of thinking of this as a userspace replacement for the oom killer, 
> it simply preempts it if userspace can provide more memory, including the 
> possibility of killing tasks itself.

How different may look idea expressed by the different phrases and cold
heads :)

-- 
	Evgeniy Polyakov
