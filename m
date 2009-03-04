Return-Path: <linux-kernel-owner+w=401wt.eu-S1755937AbZCDKkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937AbZCDKkU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 05:40:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbZCDKkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 05:40:08 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45941 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbZCDKkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 05:40:07 -0500
Subject: Re: 32bit panic on 4 sockets
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Johannes Weiner <hannes@cmpxchg.org>
In-Reply-To: <20090304103405.GA4879@elte.hu>
References: <86802c440903031458p4a72f8c8x6f91e9f58ac6bc26@mail.gmail.com>
	 <86802c440903031751y136b506uc163dd2c9023de9b@mail.gmail.com>
	 <49ADE201.7010506@kernel.org>
	 <86802c440903032257l6607972dqe2390958b18454bd@mail.gmail.com>
	 <1236155659.5330.6837.camel@laptop>  <20090304103405.GA4879@elte.hu>
Content-Type: text/plain
Date: Wed, 04 Mar 2009 11:39:50 +0100
Message-Id: <1236163190.5330.7091.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-04 at 11:34 +0100, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Tue, 2009-03-03 at 22:57 -0800, Yinghai Lu wrote:
> > > On Tue, Mar 3, 2009 at 6:05 PM, Tejun Heo <tj@kernel.org> wrote:
> > > > Looks like a genuine bootmem bug.  Cc'ing Johannes and
> > > > quoting whole body.
> > > 
> > > it is x86 32bit numa code problem. it assume bootmem will 
> > > sit on first node only.
> > 
> > Seems a bit daft to run a 32bit kernel on such a machine.. at 
> > some point we should just give up and not push this 32 bit 
> > madness any further.
> 
> it works just fine on a lot of systems - and since we keep 
> unifying a lot of these codepaths we are better off keeping it 
> all working.

Sure, but eg. running with 16GB on a 32bit system just isn't going to
work well. Same with large cpu-count, at some point you might be able to
boot, but not much else.

