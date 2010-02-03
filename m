Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360Ab0BCCMt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 21:12:49 -0500
Received: from smtp-out.google.com ([216.239.44.51]:58690 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932244Ab0BCCMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 21:12:47 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=gQEwkdVrEdHooZovZ39+2lxoo/xs62DNhPE5HgeIH+fR5ePrz2XH1Wn2BLiQOyfjG
	8ZGUYW6E9QkVTnzXGSTJA==
Date: Tue, 2 Feb 2010 18:12:41 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Lubos Lunak <l.lunak@suse.cz>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Nick Piggin <npiggin@suse.de>,
       Jiri Kosina <jkosina@suse.cz>
Subject: Re: Improving OOM killer
In-Reply-To: <20100203105236.b4a60754.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1002021809220.15327@chino.kir.corp.google.com>
References: <201002012302.37380.l.lunak@suse.cz> <alpine.DEB.2.00.1002011523280.19457@chino.kir.corp.google.com> <201002022210.06760.l.lunak@suse.cz> <alpine.DEB.2.00.1002021643240.3393@chino.kir.corp.google.com>
 <20100203105236.b4a60754.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Feb 2010, KAMEZAWA Hiroyuki wrote:

> I stopped that as I mentioned. I'm heavily disappointed with myself and
> would like not to touch oom-killer things for a while.
> 
> I'd like to conentrate on memcg for a while, which I've starved for these 3 months.
> 
> Then, you don't need to CC me.
> 

I'm disappointed to hear that, it would be helpful to get some consensus 
on the points that we can all agree on from different perspectives.  I'll 
try to find some time to develop a solution that people will see as a move 
in the positive direction.

On a seperate topic, do you have time to repost your sysctl cleanup for 
Andrew from http://marc.info/?l=linux-kernel&m=126457416729672 with the
#ifndef CONFIG_MMU fix I mentioned?
