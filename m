Return-Path: <linux-kernel-owner+w=401wt.eu-S1754811AbYKDUwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbYKDUwl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 15:52:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753541AbYKDUwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 15:52:34 -0500
Received: from casper.infradead.org ([85.118.1.10]:52997 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469AbYKDUwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 15:52:33 -0500
Subject: Re: [patch 0/7] cpuset writeback throttling
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, cl@linux-foundation.org,
       npiggin@suse.de, menage@google.com, dfults@sgi.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081104124753.fb1dde5a.akpm@linux-foundation.org>
References: <alpine.DEB.2.00.0810292337170.23858@chino.kir.corp.google.com>
	 <20081104124753.fb1dde5a.akpm@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 04 Nov 2008 21:53:08 +0100
Message-Id: <1225831988.7803.1939.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-04 at 12:47 -0800, Andrew Morton wrote:
> On Thu, 30 Oct 2008 12:23:10 -0700 (PDT)
> David Rientjes <rientjes@google.com> wrote:
> 
> > This is the revised cpuset writeback throttling patchset
> 
> I'm all confused about why this is a cpuset thing rather than a cgroups
> thing.  What are the relationships here?
> 
> I mean, writeback throttling _should_ operate upon a control group
> (more specifically: a memcg), yes?  I guess you're assuming a 1:1
> relationship here?

I think the main reason is that we have per-node vmstats so the cpuset
extention is relatively easy. Whereas we do not currently maintain
vmstats on a cgroup level - although I imagine that could be remedied.
