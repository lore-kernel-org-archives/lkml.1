Return-Path: <linux-kernel-owner+w=401wt.eu-S1759550AbXEJToq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759550AbXEJToq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 15:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755849AbXEJTok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 15:44:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754378AbXEJTok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 15:44:40 -0400
Message-ID: <46437613.4060407@redhat.com>
Date: Thu, 10 May 2007 12:44:19 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, Ulrich Drepper <drepper@redhat.com>,
       Neil Brown <neilb@suse.de>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] utimensat implementation
References: <200704262249.l3QMn5C2021588@devserv.devel.redhat.com> <17969.22692.855242.359680@notabene.brown> <46315C61.30001@redhat.com> <464363DC.7060607@redhat.com> <20070510185226.GA1458@infradead.org>
In-Reply-To: <20070510185226.GA1458@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> E.g.
> 
> long foofs_pathconf {
> 	[_PC_LINK_MAX]		= 16384,
> 	[_PC_2_SYMLINKS]	= 1,

In general I agree.  But what do you do for network filesystems?  Maybe 
we'll have a network filesystem protocol which allows to query the 
remote server about the underlying filesystem.  Then the return value is 
dynamic and it's the maximum (coarsest granularity) of the network 
filesystem itself and the underlying filesystem.

-- 
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
