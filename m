Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbZA0LXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbZA0LXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 06:23:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbZA0LXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 06:23:00 -0500
Received: from smtp-out.google.com ([216.239.33.17]:9940 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbZA0LW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 06:22:59 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-gmailtapped-by:x-gmailtapped;
	b=C7QK6bD5vfaG8qMaz0eJF+LllzcGjKPe4RqaM+d/G/xiE584UV5CQ6dxrsEDOyMh/
	wulM5rcxiRCTx9WigoRsw==
Date: Tue, 27 Jan 2009 03:21:26 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nikanth Karthikesan <knikanth@suse.de>
cc: Evgeniy Polyakov <zbr@ioremap.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>,
       =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Paul Menage <menage@google.com>, containers@lists.linux-foundation.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
In-Reply-To: <200901271638.21720.knikanth@suse.de>
Message-ID: <alpine.DEB.2.00.0901270316040.25608@chino.kir.corp.google.com>
References: <200901211638.23101.knikanth@suse.de> <200901271550.16902.knikanth@suse.de> <alpine.DEB.2.00.0901270244380.23757@chino.kir.corp.google.com> <200901271638.21720.knikanth@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-GMailtapped-By: 172.24.198.85
X-GMailtapped: rientjes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2009, Nikanth Karthikesan wrote:

> > I don't understand what you're arguing for here.  Are you suggesting that
> > we should not prefer tasks that intersect the set of allowable nodes?
> > That makes no sense if the goal is to allow for future memory freeing.
> >
> 
> No. Actually I am just wondering, will it be possible to check whether a 
> particular task has memory allocated or mmaped from this node to avoid killing 
> an innocent task.

That's certainly idealistic, but cannot be done in an inexpensive way that 
would scale with the large systems that clients of cpusets typically use.
