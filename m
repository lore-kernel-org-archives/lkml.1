Return-Path: <linux-kernel-owner+w=401wt.eu-S1761475AbZENMXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761475AbZENMXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 08:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761251AbZENMXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 08:23:16 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50569 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761100AbZENMXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 08:23:15 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [patch 1/5] oom: cleanup android low memory killer
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
       Greg KH <greg@kroah.com>, Arve Hjonnevag <arve@android.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, San Mehat <san@android.com>,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>
In-Reply-To: <alpine.DEB.2.00.0905111241120.23739@chino.kir.corp.google.com>
References: <49FF7B02.9050608@redhat.com> <alpine.DEB.2.00.0905111241120.23739@chino.kir.corp.google.com>
Message-Id: <20090514211934.F5B3.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 14 May 2009 21:23:13 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sorry late responce.

> On Mon, 4 May 2009, Rik van Riel wrote:
> 
> > > There was an interest in a low mem userspace notifier that applications can
> > > poll() on at configurable low mem levels to react accordingly.  This would
> > > probably address the problem that the Android team is trying to fix.
> > 
> > This would also make it easier for virtual machines to be
> > ballooned down to size when the host experiences memory
> > pressure.
> > 
> > The low memory notification could also be useful for JVMs,
> > databases that do (some of) their own caching and any garbage
> > collected program in general.
> > 
> 
> I agree, and I'd suggest that it be implemented as a cgroup so that 
> individual sets of tasks can be responsible for their own lowmem 
> notifiers.
> 
> KOSAKI, you were pushing the /dev/mem_notify patchset last year from 
> Marcelo.  Do you have any plans of recreating that in a cgroup or have you 
> dropped it?

sorry, I've pending this because I think I have to stabilize VM 
as top priority.

I can't say when I resume this works, sorry.



