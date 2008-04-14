Return-Path: <linux-kernel-owner+w=401wt.eu-S1761370AbYDNTvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761370AbYDNTvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 15:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757506AbYDNTvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 15:51:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43889 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756944AbYDNTvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 15:51:01 -0400
Date: Mon, 14 Apr 2008 12:39:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: manfred@colorfullife.com, linux-kernel@vger.kernel.org, serue@us.ibm.com,
       ebiederm@xmission.com, xemul@openvz.org, sukadev@us.ibm.com,
       pierre.peiffer@bull.net
Subject: Re: [PATCH 1/2] fix sys_unshare()+SEM_UNDO: add support for
 CLONE_SYSVSEM
Message-Id: <20080414123917.b750886a.akpm@linux-foundation.org>
In-Reply-To: <20080414145840.GA15667@sergelap.austin.ibm.com>
References: <200804130848.m3D8mU7D007104@mail.q-ag.de>
	<20080413015936.580bf7fe.akpm@linux-foundation.org>
	<4801F038.8020003@colorfullife.com>
	<20080414145840.GA15667@sergelap.austin.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008 09:58:40 -0500
"Serge E. Hallyn" <serue@us.ibm.com> wrote:

> Quoting Manfred Spraul (manfred@colorfullife.com):
> > Andrew Morton wrote:
> >> On Sun, 13 Apr 2008 10:04:17 +0200 Manfred Spraul 
> >> <manfred@colorfullife.com> wrote:
> >>
> >>> sem_undo_list **new_ulistp)
> >>>  {
> >>> -	if (unshare_flags & CLONE_SYSVSEM)
> >>> -		return -EINVAL;
> >>> +	if (unshare_flags & CLONE_SYSVSEM) {
> >>> +		*new_ulistp = (void*)1;
> >>> +	}
> >>>     
> >>
> >> And can we do anything nicer than this?
> >>
> >>   
> > Attached is an alternative. If you prefer it, I'll send another patch set.
> 
> FWIW I definately far far prefer this version  :)

Oh, OK.

I guess I'll drop what I have.  Manfred, can we please have a new patchset?

We might end up slipping this back to 2.6.25.1.  Would that be a bad thing?
