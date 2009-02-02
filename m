Return-Path: <linux-kernel-owner+w=401wt.eu-S1756028AbZBBPtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbZBBPtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 10:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbZBBPtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 10:49:06 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:40341 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbZBBPtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 10:49:05 -0500
Subject: Re: [RFC v7] wait: prevent exclusive waiter starvation
From: Chris Mason <chris.mason@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Matthew Wilcox <matthew@wil.cx>, Chuck Lever <cel@citi.umich.edu>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Ingo Molnar <mingo@elte.hu>, stable@kernel.org
In-Reply-To: <1233239675.10354.18.camel@think.oraclecorp.com>
References: <20090123095904.GA22890@cmpxchg.org>
	 <20090123113541.GB12684@redhat.com> <20090123133050.GA19226@redhat.com>
	 <20090126215957.GA3889@cmpxchg.org> <20090127032359.GA17359@redhat.com>
	 <20090127193434.GA19673@cmpxchg.org> <20090127200544.GA28843@redhat.com>
	 <20090128091453.GA22036@cmpxchg.org> <20090129044227.GA5231@redhat.com>
	 <20090128233734.81d8004a.akpm@linux-foundation.org>
	 <20090129083108.GA27495@redhat.com>
	 <20090129011143.884e5573.akpm@linux-foundation.org>
	 <1233239675.10354.18.camel@think.oraclecorp.com>
Content-Type: text/plain
Date: Mon, 02 Feb 2009 10:47:47 -0500
Message-Id: <1233589667.18113.24.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.498715AB.02D8:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-29 at 09:34 -0500, Chris Mason wrote:

> > > > So I think we're saying that
> > > > lock_page_killable-avoid-lost-wakeups.patch actually did fix the bug?
> > > 
> > > I think yes,
> > > 
> 
> Our test case that was able to reliably trigger the bug was fixed by
> lock_page_killable-avoid-lost-wakeups.patch.
> 
> I'll ask them to test v7 as well.  The run takes about a day, so
> confirmation will take a bit.

v7 went through a total of 5 runs and passed all of them.  Unpatched we
would fail after one run, so I think this does fix it.

-chris




