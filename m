Return-Path: <linux-kernel-owner+w=401wt.eu-S932791AbZLJSFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932791AbZLJSFB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 13:05:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761366AbZLJSFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 13:05:00 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:39328 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761318AbZLJSFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 13:05:00 -0500
Date: Thu, 10 Dec 2009 12:04:45 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Ingo Molnar <mingo@elte.hu>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       minchan.kim@gmail.com
Subject: Re: [RFC mm][PATCH 2/5] percpu cached mm counter
In-Reply-To: <20091210173819.GA5256@elte.hu>
Message-ID: <alpine.DEB.2.00.0912101203320.5481@router.home>
References: <20091210163115.463d96a3.kamezawa.hiroyu@jp.fujitsu.com> <20091210163448.338a0bd2.kamezawa.hiroyu@jp.fujitsu.com> <20091210075454.GB25549@elte.hu> <20091210172040.37d259d3.kamezawa.hiroyu@jp.fujitsu.com> <20091210083310.GB6834@elte.hu>
 <alpine.DEB.2.00.0912101134220.5481@router.home> <20091210173819.GA5256@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Dec 2009, Ingo Molnar wrote:

>
> * Christoph Lameter <cl@linux-foundation.org> wrote:
>
> > On Thu, 10 Dec 2009, Ingo Molnar wrote:
> >
> > >
> > > No, i'm not suggesting that - i'm just suggesting that right now MM
> > > stats are not very well suited to be exposed via perf. If we wanted to
> > > measure/sample the information in /proc/<pid>/statm it just wouldnt be
> > > possible. We have a few events like pagefaults and a few tracepoints as
> > > well - but more would be possible IMO.
> >
> > vital MM stats are exposed via /proc/<pid> interfaces. Performance
> > monitoring is something optional MM VM stats are used for VM decision
> > on memory and process handling.
>
> You list a few facts here but what is your point?

The stats are exposed already in a well defined way. Exposing via perf is
outside of the scope of his work.

